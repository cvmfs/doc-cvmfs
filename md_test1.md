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


## Admonition
See [official doc](https://myst-parser.readthedocs.io/en/latest/syntax/admonitions.html)

Use
```
:::{note}
  Some note
:::
```
to create a note.

:::{note}
  Some note
:::

For custom title
```
:::{admonition} My custom title
  :class: note

  My custom note
:::
```

:::{admonition} My custom title
  :class: note

  My custom note
:::

### Other supported admonitions
- attention
- caution
- danger
- error
- hint
- important
- note
- seealso
- tip

:::{attention}
  Some attention
:::

:::{caution}
  Some caution
:::

:::{danger}
  Some danger
:::

:::{error}
  Some error
:::

:::{important}
  Some important
:::

:::{tip}
  Some tip
:::

:::{note}
  Some note
:::

:::{seealso}
  Some seealso
:::

{deprecated}`1.5 `
Use {func}`spam` instead.

Further reads are [Get started with MyST in Sphinx](https://myst-parser.readthedocs.io/en/v0.17.1/sphinx/intro.html)
and [MyST - Directives](https://myst-parser.readthedocs.io/en/v0.17.1/syntax/syntax.html#syntax-directives)

# Sphinx Design

Add `sphinx_design` to `extensions` in `conf.py` and install it for python with `pip install sphinx-design`.

[Official doc](https://sphinx-design.readthedocs.io/en/furo-theme/)

This allows to do stuff like e.g. this

## Tabs

```
::::{tab-set}

:::{tab-item} Label1
Content 1
:::

:::{tab-item} Label2
Content 2
:::

::::
```

::::{tab-set}

:::{tab-item} Label1
Content 1
:::

:::{tab-item} Label2
Content 2
:::

::::

## Dropdowns

```
:::{dropdown} Dropdown title
:animate: fade-in-slide-down
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed iaculis arcu vitae odio gravida congue. Donec porttitor ac risus et condimentum. Phasellus bibendum ac risus a sollicitudin. Proin pulvinar risus ac mauris aliquet fermentum et varius nisi. Etiam sit amet metus ac ipsum placerat congue semper non diam. Nunc luctus tincidunt ipsum id eleifend. Ut sed faucibus ipsum. Aliquam maximus dictum posuere. Nunc vitae libero nec enim tempus euismod. Aliquam sed lectus ac nisl sollicitudin ultricies id at neque. Aliquam fringilla odio vitae lorem ornare, sit amet scelerisque orci fringilla. Nam sed arcu dignissim, ultrices quam sit amet, commodo ipsum. Etiam quis nunc at ligula tincidunt eleifend.
:::
```

:::{dropdown} Dropdown title
:animate: fade-in-slide-down
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed iaculis arcu vitae odio gravida congue. Donec porttitor ac risus et condimentum. Phasellus bibendum ac risus a sollicitudin. Proin pulvinar risus ac mauris aliquet fermentum et varius nisi. Etiam sit amet metus ac ipsum placerat congue semper non diam. Nunc luctus tincidunt ipsum id eleifend. Ut sed faucibus ipsum. Aliquam maximus dictum posuere. Nunc vitae libero nec enim tempus euismod. Aliquam sed lectus ac nisl sollicitudin ultricies id at neque. Aliquam fringilla odio vitae lorem ornare, sit amet scelerisque orci fringilla. Nam sed arcu dignissim, ultrices quam sit amet, commodo ipsum. Etiam quis nunc at ligula tincidunt eleifend.
:::

## Images

Images can be included with `![Alternative title of the image](_static/concept-generic.svg)`.

![Alternative title of the image](_static/concept-generic.svg)

If they need special options (e.g. size) use
```html
<img src="_static/concept-generic.svg"
     alt="Alternative title of the image"
     style="float: left; width: 50%;" />

```

<img src="_static/concept-generic.svg"
     alt="Alternative title of te image"
     style="float: left; width: 50%;" />

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

## Mermaid graphics
Can be included with

~~~
```{mermaid}
graph LR
  a --> b
```
~~~

```{mermaid}
graph LR
  a --> b
```

## Other Markdown Stuff
- `*Cursive*` *Cursive*
- `**Bold**` **Bold**
- `<u>something</u>` underline <u>something</u>
- To comment stuff out within the md file use html comment `< !-- remove the space before the ! for comment section -->`

