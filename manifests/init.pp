# == Class: memSQL
#
# Install memSQL.
#
# === Parameters
#
# [*version*]
#   Version to install.
#
# [*license*]
#   License provided by memSQL.
#
# [*memsql_src_dir*]
#   Location to unpack source code before building and installing it.
#   Default: /opt/memsql-src
#
# [*memsql_bin_dir*]
#   Location to install memsql binaries.
#   Default: /opt/memsql
#
# === Examples
#
# include memsql
#
# class { 'memsql':
#   version        => '3.1',
#   license        => 'LICENSE_KEY'
#   memsql_src_dir => '/path/to/memsql-src',
#   memsql_bin_dir => '/path/to/memsql',
# }
#
# === Authors
#
# Dale-Kurt Murray
#
# === Copyright
#
# Copyright 2014 Dale-Kurt Murray, unless otherwise noted.
#

class memsql (
  $version        = $memsql::params::version,
  $license        = $memsql::params::license,
  $memsql_src_dir = $memsql::params::memsql_src_dir,
  $memsql_bin_dir = $memsql::params::memsql_bin_dir,
  $memsql_user    = $memsql::params::memsql_user,
  $memsql_group   = $memsql::params::memsql_group
) inherits memsql::params {

  include wget
  include gcc

  $memsql_pkg_name = "memsqlbin_amd64.tar.gz"
  $memsql_pkg      = "${memsql_src_dir}/${memsql_pkg_name}"

  group { $memsql_group:
    ensure => present,
  }

  user { $memsql_user:
    ensure => present,
    gid => $memsql_group,
    shell => '/bin/bash',
    home => $memsql_bin_src,
    managehome => 'true',
  }

  file { 'ownership':
    owner => $memsql_user,
    group => $memsql_group,
    path  => $memsql_bin_dir,
    mode  => 0700,
  }

  file { $memsql_src_dir:
    ensure => directory,
  }

#  file { $memsql_bin_dir:
#    ensure => directory,
#  }

  exec { 'get-memsql-pkg':
    command => "wget http://download.memsql.com/${license}/${memsql_pkg_name}",
    cwd     => $memsql_src_dir,
    path    => "/usr/bin",
    unless  => "test -f ${memsql_pkg}",
    require => File[$memsql_src_dir],
  }

  exec { 'unpack-memsql':
    command => "tar --strip-components 1 -xzf ${memsql_pkg} -C ${memsql_bin_dir}",
    cwd     => $memsql_src_dir,
    path    => '/bin:/usr/bin',
    unless  => "test -f ${memsql_src_dir}/Makefile",
    require => Exec['get-memsql-pkg'],
  }

  file { "memsql-init":
    ensure  => present,
    path    => "/etc/init.d/memsql",
    mode    => '0755',
    content => template('memsql/memsql.init.erb'),
    notify  => Service["memsql"],
  }
  
  service { "memsql":
    ensure    => running,
    name      => "memsql",
    enable    => true,
    require   => [ File["memsql-init"], Exec["get-memsql-pkg"], Exec["unpack-memsql"] ],
  }
  
}

