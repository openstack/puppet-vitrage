Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-vitrage.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

vitrage
=======

#### Table of Contents

1. [Overview - What is the vitrage module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with vitrage](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Beaker-Rspec - Beaker-rspec tests for the project](#beaker-rpsec)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors - Those with commits](#contributors)
9. [Release Notes - Release notes for the project](#release-notes)
10. [Repository - The project source code repository](#repository)

Overview
--------

Vitrage module is an engine for organizing, analyzing and expanding OpenStack alarms & events, yielding insights regarding the Root Cause of problems and deducing the existence of problems before they are directly detected.

Module Description
------------------

The vitrage puppet module is a thorough attempt to make Puppet capable of managing the entirety of vitrage.

Setup
-----

**What the vitrage module affects**

* [Vitrage](https://docs.openstack.org/vitrage/latest/), the Root Cause Analysis engine for organizing, analyzing and expanding OpenStack alarms & events for Openstack.

### Installing vitrage

    vitrage is not currently in Puppet Forge, but is anticipated to be added soon.  Once that happens, you'll be able to install vitrage with:
    puppet module install openstack/vitrage

### Beginning with vitrage

To utilize the vitrage module's functionality you will need to declare multiple resources.  The following is a modified excerpt from the [openstack module](https://github.com/stackforge/puppet-openstack).  This is not an exhaustive list of all the components needed, we recommend you consult and understand the [openstack module](https://github.com/stackforge/puppet-openstack) and the [core openstack](http://docs.openstack.org) documentation.

Implementation
--------------

### vitrage

vitrage is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
------------

* None.

Beaker-Rspec
------------

This module has beaker-rspec tests

To run the tests on the default vagrant node:

```shell
bundle install
bundle exec rake acceptance
```

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* The github [contributor graph] (https://github.com/openstack/puppet-vitrage/graphs/contributors)

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-vitrage

Repository
----------

* https://git.openstack.org/cgit/openstack/puppet-vitrage
