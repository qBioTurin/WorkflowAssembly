import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


REPO = Path(__file__).resolve().parent.parent
LAUNCHER = REPO / "bin" / "assembly-run"


class AssemblyRunTest(unittest.TestCase):
    def run_launcher(self, *arguments: str) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(LAUNCHER), *arguments, "--prepare-only"],
            cwd=REPO,
            text=True,
            capture_output=True,
            check=False,
        )

    def base_arguments(self, root: Path, domain: str) -> list[str]:
        reads = root / "reads"
        reads.mkdir()
        return [
            "--domain",
            domain,
            "--fastq-directory",
            str(reads),
            "--seq-technology",
            "nanopore",
            "--lineage",
            "test-lineage",
            "--taxon",
            "1",
            "--output",
            str(root / "output"),
            "--workspace",
            str(root / "workspace"),
        ]

    def test_prokaryotic_transfer_contains_only_bakta(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            bakta = root / "bakta"
            bakta.mkdir()
            result = self.run_launcher(
                *self.base_arguments(root, "prokaryotic"),
                "--bakta-db",
                str(bakta),
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            config = json.loads((root / "workspace" / "config.yml").read_text())
            self.assertIn("db_bakta", config)
            self.assertNotIn("prot_seq", config)
            self.assertEqual(config["db_bakta"]["class"], "Directory")
            bakta_sbatch = (root / "workspace" / "sbatch" / "bakta.sh").read_text()
            self.assertIn("/opt/adw/bin/adw run", bakta_sbatch)
            self.assertNotIn("srun /opt/adw/bin/adw", bakta_sbatch)

    def test_eukaryotic_shared_contains_only_protein_path(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            remote_fasta = "/storage/references/uniprot/ascomycota.fasta"
            result = self.run_launcher(
                *self.base_arguments(root, "eukaryotic"),
                "--reference-mode",
                "hpc-shared",
                "--protein-fasta",
                remote_fasta,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            config = json.loads((root / "workspace" / "config.yml").read_text())
            self.assertEqual(config["prot_seq"], remote_fasta)
            self.assertNotIn("db_bakta", config)
            workflow = (root / "workspace" / "workflow.cwl").read_text()
            self.assertIn("prot_seq: string?", workflow)
            self.assertIn("db_bakta: string?", workflow)
            streamflow = (root / "workspace" / "streamflow.yml").read_text()
            self.assertIn("file: workflow.cwl", streamflow)
            self.assertIn("settings: config.yml", streamflow)

    def test_overrides_slurm_placement(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            bakta = root / "bakta"
            bakta.mkdir()
            result = self.run_launcher(
                *self.base_arguments(root, "prokaryotic"),
                "--bakta-db",
                str(bakta),
                "--slurm-partition",
                "test-partition",
                "--slurm-reservation",
                "none",
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            sbatch = (root / "workspace" / "sbatch" / "bakta.sh").read_text()
            self.assertIn("#SBATCH --partition=test-partition", sbatch)
            self.assertNotIn("#SBATCH --reservation=", sbatch)

    def test_rejects_reference_for_the_other_domain(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            bakta = root / "bakta"
            bakta.mkdir()
            result = self.run_launcher(
                *self.base_arguments(root, "eukaryotic"),
                "--protein-fasta",
                str(root / "proteins.fasta"),
                "--bakta-db",
                str(bakta),
            )
            self.assertEqual(result.returncode, 2)
            self.assertIn("--bakta-db is not used", result.stderr)


if __name__ == "__main__":
    unittest.main()
