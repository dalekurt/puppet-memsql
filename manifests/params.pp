# == Class: memsql::params
#
# memsql params.
#
# === Parameters
#
# === Authors
#
# Dale-Kurt Murray
#
# === Copyright
#
# Copyright 2014 Dale-Kurt Murray, unless otherwise noted.
#
class memsql::params {

  $version = '3.3'
  $license = '6f1baebd40ea4b14bea2c8bdf2849552'
  $memsql_src_dir = '/opt/memsql-src'
  $memsql_bin_dir = '/opt/memsql'
  $memsql_user    = 'memsql'
  $memsql_group   = 'memsql'

}
