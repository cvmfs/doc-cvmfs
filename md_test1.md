(md_test_label1)=
# Markdown Test

- This [here](https://docs.readthedocs.io/en/stable/guides/migrate-rest-myst.html) is a documentation how to migrate from rst to md

- Most important functionality needed here is listed below

(md_test_label2)=
## Codesections
Inline codesection `my code is here` written by using `` around the text

### Codeblocks

Using ``` or ~~~ following the optional code block type (c++, vim, py,...) and a new line. 

~~~
```vim
sudo cvmfs_config setup

cvmfs_config chksetup
--> OK
```
~~~

creates

```vim
sudo cvmfs_config setup

cvmfs_config chksetup
--> OK
```


(md_test_label3)=
## Tables
```
|Option|Function|
|---|---|
|CVMFS_HTTP_PROXY|Proxy setting for repos|
|CVMFS_QUOTA_LIMIT|Quota in MB of local cvmfs cache|
```

creates

|Option|Function|
|---|---|
|CVMFS_HTTP_PROXY|Proxy setting for repos|
|CVMFS_QUOTA_LIMIT|Quota in MB of local cvmfs cache|

## Labels

### Reference to a file

`[test](cpt-xcache.rst)` creates [test](cpt-xcache.rst)

### Create custom label
In markdown
```
(md_test_label3)=
## Tables
and the normal text follows
this label style is not a markdown style specific to sphinx
```

In rst
```
.. _apxsct_serverparameters:
```

### Referencing a custom label
- Does not dependent if it is in local file or some other part of the documentation
- Labels must be unique accross all files

In markdown
```
{ref}`Use label from this md file<md_test_label3>`.
{ref}`md_test2_label`.
{ref}`If using text-based labels you need to provide test <md_test2_label2>`.
{ref}`Use label from rst part of docs without underscore _ <apxsct_serverparameters>`.

```

{ref}`Use label from this md file<md_test_label3>`.

{ref}`md_test2_label`.

{ref}`If using text-based labels you need to provide test <md_test2_label2>`.

{ref}`Use label from rst part of docs without underscore _ <apxsct_serverparameters>`.


## Other Markdown Stuff
- `<u>something</u>` underline <u>something</u>
- To comment stuff out within the md file use html comment `< !-- remove the space before the ! for comment section -->`


