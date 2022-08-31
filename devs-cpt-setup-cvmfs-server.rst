Setup of CernVM-FS Server
=========================

**Prerequisits**

- ``cvmfs`` is installed
- ``autofs`` is diabled

**Goal**
 - Create, modify and delete CernVM-FS repository called ``local.test.repo`` 

**NOTE**: If you do not disable ``autofs`` before any of the CernVM-FS server manipulation commands you can get in a broken state which can only be resolved by restarting the entire machine! (Independent of if you later on disable ``autofs``)

::

    ####################################################
    # CREATE repo
    ####################################################
    sudo cvmfs_server mkfs local.test.rep

    ####################################################
    # START MODIFY files - this is done in a transaction
    ####################################################

    # start transaction
    sudo cvmfs_server transaction local.test.repo

    # Perform the file manipulations
    sudo cp /home/myuser/testfile*.txt /cvmfs/local.test.repo/
    sudo rm /cvmfs/local.test.repo/testfile2.txt

    # Finalize transaction
    sudo cvmfs_server publish 

    ####################################################
    # END MODIFY files - this is done in a transaction
    ####################################################

    ####################################################
    # DELETE repo
    ####################################################
    sudo cvmfs_server rmfs local.test.repo

    # if it doesnt work use -f flag
    sudo cvmfs_server rmfs -f local.test.repo