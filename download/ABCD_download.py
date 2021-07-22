
# coding: utf-8

# In[36]:


import pandas
import os 
import sys
import datetime
from nda_aws_token_generator import *
from pathlib import Path


# In[37]:


def update_aws_config(username,password,web_service_url='https://nda.nih.gov/DataManager/dataManager'):
    
    generator = NDATokenGenerator(web_service_url)
    token = generator.generate_token(username, password)
    config_file=os.path.join(str(Path.home()),'.aws','credentials')
    f=open(config_file, 'w')
    f.write('[default]\n'
                     'aws_access_key_id = %s\n'
                     'aws_secret_access_key = %s\n'
                     'aws_session_token = %s\n'
                     %(token.access_key,
                       token.secret_key,
                       token.session)
                    )
    f.close()


# In[38]:


def ABCD_download(id_list,table_file,username,password,save_dir,mod):
    '''
    Download image from ABCD dataset
    
    Input:
    id_list: list of the subjects you want to download the images
    table_file: full path of the fmriresults01.txt
    username: username of your NDAR account
    password: password of your NDAR account
    save_dir: the directory you want to save the downloaded files
    mod: the image modality you want to download. choose from: [t1,t2,dwi,rs,mid,nback,sst]
    
    Ouput:NA
    '''
    # update config file
    update_aws_config(username,password)
    expire_time = datetime.datetime.now() + datetime.timedelta(hours=10)
    
    # read image table
    with open(id_list) as f:
        id_list = f.read().splitlines()
    
    image_table=pandas.read_table(table_file,sep='\t',usecols=['subjectkey','derived_files'])
    all_image = image_table['derived_files']
    
    # download image from aws server
    task_codes = ABCD_task_coding()
    keyword =  task_codes[mod]
    for id in id_list:
        print(id)
        ind = image_table['subjectkey'].str.contains(id)
        subject_images = all_image[ind]
        for curr_image in subject_images:
            if (keyword in curr_image):
                print(curr_image)
                image_name = curr_image.rpartition('/')[-1]
                filepath = os.path.join(save_dir, image_name)
                if not os.path.exists(filepath):
                    os.system('aws s3 cp '+curr_image+' '+filepath)
        
        # update config file when token expire
        if datetime.datetime.now() > expire_time:
            update_aws_config(username,password)
            expire_time = datetime.datetime.now() + datetime.timedelta(hours=10)


# In[39]:


def ABCD_task_coding():
    '''
    Define the keywords in the iamge filename that can specify the image modality.
    
    Returns:
    task_coding: a dictionary for the matching keyword of each image modality.
    
    '''
    task_coding = {
        "t1":"MPROC-T1",
        "t2":"MPROC-T2",
        "dwi":"MPROC-DTI",
        "rs":"rsfMRI",
        "mid":"MID-fMRI",
        "nback":"nBack-fMRI",
        "sst":"SST-fMRI"}
    return task_coding


# In[41]:


if __name__ == "__main__":
    if (len(sys.argv) >= 5):
        username = input("type your NDAR account name: ")
        password = input("type your NDAR account passward: ")
        # download the images for each modality sequentially
        for i in range(len(sys.argv)-4):
            print('---------------downloading '+sys.argv[4+i]+' images---------------')
            ABCD_download(sys.argv[1],sys.argv[2],username,password,sys.argv[3],sys.argv[4+i])
        print('---------------------------------download finished-----------------------------------------')
    else:
        print("ERROR: not enough inputs")

