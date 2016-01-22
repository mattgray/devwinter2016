devwinter 2016 - My first unikernel with Mirage OS
==================================================

Slides are in `./slides`

Examples are in `./cat_server`

Useful commands reference
-------------------------

To bring up the dev environment:

`vagrant init mattg/mirage-xen-virtualbox`

`vagrant up --provider=virtualbox`

`vagrant ssh` - Access the box

Mirage OS commands:

`mirage configure --unix`

or

`mirage configure --xen`

`make`
