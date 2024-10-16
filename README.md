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
mkdir INLISTS INPUTMODELS
```
3) Tweak slurm settings in the file `sjobrun.sh` as needed
4) If you would like to pull and link a remote git repository, run something like:
```
rmdir INLISTS
git clone git@github.com:<USERNAME>/<REPONAME>.git INLISTS
```

### Usage steps
1) Create a MESA inlist file as you would normally with the following constraints:
    - In the file's `controls` section, leave the `logs_directory` empty, or set `logs_directory="LOGS"`
    - If loading set the load to `model_filepath="INPUTMODELS/some_descriptive_name"`
    - If saving models, set the savepath to `model_filepath="MODELS/some_descriptive_name"`
2) Place the inlist file in the folder `INLISTS`
    - To help organize, the inlists can also be placed in a subfolder structure in the `INLISTS` folder
    - Version management can be done with git repo in the `INLISTS` folder
3) If required, place the model file to be loaded in the folder `INPUTMODELS`
    - To help organize, the model files can be placed in a subfolder structure in the `MODELS` folder
3) Execute the script `run.sh` and select the inlist you want to run by entering the corresponding number
4) Hook into current feed of last slurm log with `hooklastlog.sh`
    - Enter `CTRL+c` to exit
4) Open most recent slurm log in vim with `openlastlog.sh`

### Folder overview
All the folders that are written in all caps have some contents related to the runs.
1) `INLISTS` contains all the inlist files
2) `INPUTMODELS` contains all the saved models
3) `JOBLOGS` contains all the slurm logs
4) `LOGS` contains all the log folders
5) `MODELS` contains all the models to be used as input

`JOBLOGS`, `LOGS` and `MODELS` are all symlinks to folders located in the `RESULTS` folder, here a folder called `<inlistname>_<unixtimestamp>` is created when each run commences.


Possible future features
------------------------
- Support for custom run_star_extras.f90 files
- Support for multiple inlist files for better organization
    - Both of the above features could be realized e. g. by having folders sitting in the `INLISTS` folder, and copying their contents over to the main folder on demand.
- Fix `.lock` file not getting removed automatically when slurmjob is uncleanly terminated


TODO
----
- Make the script `run.sh` fail and terminate without submitting slurmjob when compilation with selected inlist fails
- Lock does not yet get removed when slurmjob is terminated instead of finished or crashed
- Remove the filtering commands (tail etc.) in `hooklastlog.sh` and `openlastlog.sh`, redundant because new folderstructure only permits one log per folder anyway
- Add support for more complicate

License
-------
Mesa is licensed under GNU General Public License Version 2.
