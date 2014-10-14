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
#   Location to install redis binaries.
#   Default: /opt/memsql
#
# === Examples
#
# include redis
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

class (
  $version        = $memsql::params::version,
  $license        = $memsql::params::license,
  $memsql_src_dir = $memsql::params::memsql_src_dir,
  $memsql_bin_dir = $memsql::params::memsql_bin_dir,

) inherits memsql::params {

  include wget
  include gcc

  $memsql_pkg_name = "memsqlbin_amd64.tar.gz"
  $memsql_pkg      = "${memsql_src_dir}/${memsql_pkg_name}"
}

file { $memsql_src_dir:
  ensure => directory,

}

exec { 'get-memsql-pkg':
  command => "wget http://download.memsql.com/${license}/${memsql_pkg_name}",
  cwd     => $memsql_src_dir,
  path    => "/usr/bin",
  unless  => "test -f ${memsql_pkg}",
  require => File[$memsql_src_dir],
}

exec { 'unpack-memsql':
  command => "tar --strip-components 1 -xzf ${memsql_pkg}",
  cwd     => $memsql_src_dir,
  path    => '/bin:/usr/bin',
  unless  => "test -f ${memsql_src_dir}/Makefile",
  require => Exec['get-memsql-pkg'],
}
