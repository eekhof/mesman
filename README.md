MESA stellar evolution code manager
===================================
This little project is supposed to help manage inlists, runs and outputs of the [MESA stellar evolution code](https://mesastar.org/) on a server running the [Slurm workload manager](https://slurm.schedmd.com/). It uses the `star/work` directory from MESA.

Instructions
------------
### Installation
1) [Install and set up MESA](https://docs.mesastar.org/en/24.08.1/installation.html)
2) Run the following commands
```
git clone git@github.com:eekhof/mesman.git
cd mesman
mkdir INLISTS JOBLOGS LOGS MODELS
```
3) Tweak slurm settings in the file `sjobrun.sh` as needed
4) If you would like to pull and link a remote git repository, run something like:
```
rmdir INLISTS
git clone git@github.com:<USERNAME>/<REPONAME>.git INLISTS
echo "INLISTS/*" >> .gitignore
```

### Usage steps
1) Create a MESA inlist file as you would normally with the following constraints:
    - In the file's `controls` section, set `logs_directory="LOGS/some_descriptive_name"`
    - If loading or saving models, set the load/savepath to `model_filepath="MODELS/some_descriptive_name"`
    - It must be named differently from all other inlists, e. g. `some_descriptive_name`
2) Place the inlist file in the folder `INLISTS`
    - Version management can be done with git repo in the `INLISTS` folder
3) Execute the script `run.sh` and select the inlist you want to run by entering the corresponding number
4) Hook into current feed of last slurm log with `hooklastlog.sh`
    - Enter `CTRL+c` to exit
4) Open most recent slurm log in vim with `openlastlog.sh`

### Folder overview
All the folders that are written in all caps have some contents related to the runs.
1) `INLISTS` contains all the inlist files
4) `JOBLOGS` contains all the slurm logs
2) `LOGS` contains all the log folders
3) `MODELS` contains all the saved and input models


Possible future features
------------------------
- Support for custom run_star_extras.f90 files
- Support for multiple inlist files for better organization
    - Both of the above features could be realized e. g. by having folders sitting in the `INLISTS` folder, and copying their contents over to the main folder on demand.
- Add protection against running a new simulation while the other one is still running
    - This could be done by checking if the log of the last slurmjob ended cleanly
- Add confirmation when inlist to be used would overwrite logs folder or model
- Alternatively automatically add Unix-Timestamp to every logfolder and model name


TODO
----
- Make the script `run.sh` fail and terminate without submitting slurmjob when compilation with selected inlist fails


License
-------
Mesa is licensed under GNU General Public License Version 2.
