# WorkflowAssembly
### How to run
To run the workflow in your environment you should install streamflow at the 0.2.0.dev10 version.
If you prefer you can create a python virual environment: 
```
python3 -m venv venv
. ./venv/bin/activate
pip install streamflow==0.2.0.dev10
```
At the moment, you need a SLURM installation in which you have a user with your public key. Then you should change the streamflow.yml file to set your configurations.
Then change the config.yml with your data and parameters.

To run the workflow use following command:
```
bash runStreamflow.sh
```
