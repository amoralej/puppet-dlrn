# == Class: dlrn::rdoinfo
#
#  This class sets up an rdoinfo user for DLRN
#

class dlrn::rdoinfo (
) {

  user { 'rdoinfo':
    comment    => 'rdoinfo user',
    groups     => ['users', 'mock'],
    home       => '/home/rdoinfo',
    managehome => true,
  } ->
  file { '/home/rdoinfo':
    ensure => directory,
    mode   => '0755',
    owner  => 'rdoinfo',
  } ->
  exec { 'ensure home contents belong to rdoinfo':
    command => 'chown -R rdoinfo:rdoinfo /home/rdoinfo',
    path    => '/usr/bin',
    timeout => 100,
  } ->
  vcsrepo { '/home/rdoinfo/rdoinfo':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/redhat-openstack/rdoinfo',
    user     => 'rdoinfo',
  }

  file { '/usr/local/bin/rdoinfo-update.sh':
    ensure => present,
    source => 'puppet:///modules/dlrn/rdoinfo-update.sh',
    mode   => '0755',
  }

  cron { 'rdoinfo':
    command => '/usr/local/bin/rdoinfo-update.sh',
    user    => 'rdoinfo',
    hour    => '*',
    minute  => '7'
  }

}
