# Download ABCD tabular data

1. Download [NDAR Download manager](https://nda.nih.gov/DownloadManager.html)
2. Open the download manager and type your NDAR account name and password
3. Choose the package ABCDstudyNDA and download
4. After downloading, you will see a folder `ABCDstudyNDA` containing all the tables. There is a table called `fmriresults01.txt`
that will be used for the following steps


# Download ABCD imaging data

### Prerequisites
* Successfully downloaded ABCD tabular data and have a table file `fmriresults01.txt`
* Have installed AWS command line tool https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html and the AWS config file is in the default location: ~/.aws/
* Have python3

### Downloading
```
python ABCD_download.py [id_list] [table_file] [save_dir] [image_mod]
```
- id_list is the list of subject ID for the subjects you want to download
- table_file is the location of `fmriresults01.txt`
- save_dir is the location you want to download the images to
- image_mod is the imaging modalities you want to download. Choose from t1, t2, dti, rs, mid, nback, sst. This argument can be one of the above modalities or multiple modalities separated by space.

For example, to download rest-fMRI images:
```
 python ABCD_download.py subjects_with_all_task.txt ABCD_table/fmriresults01.txt ~/ABCD_images rs
 ```

OR to download rest-fMRI, t1, and MID task-fMRI:
```
python ABCD_download.py subjects_with_all_task.txt ABCD_table/fmriresults01.txt ~/ABCD_images rs t1 mid
``` 

After execute the above command, you will be ask for your NDAR account name and password. Type them in and download will start.

# Check your download [optional]
After downloading and decompressing of data, you might want to check if you have download all the images. You can check this using `ABCD_check_download.m` in this folder.
