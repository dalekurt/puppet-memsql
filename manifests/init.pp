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
