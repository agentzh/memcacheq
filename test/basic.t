#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Memcached::libmemcached qw(/^memcached/);
use Test::More 'no_plan';

#warn $FindBin::Bin;

system("rm -rf $FindBin::Bin/../mydata");
system("$FindBin::Bin/../memcacheq -d -p 22202 -B 4064 -r -c 1024 -m 64 -A 4096 -H $FindBin::Bin/../mydata -N -v > ./testenv.log 2>&1");

my $memc = memcached_create();
memcached_server_add($memc, "localhost", 22202);

my $q = "test" . time;

my $ret;
my $err;
my $max_size = 10;

$ret = memcached_set($memc, $q, 'abc');
$err = $memc->errstr;
ok(!$ret, 'not add queue yet.');
is($err, "NOT FOUND");

$ret = memcached_add($memc, $q, 0);
$err = $memc->errstr;
ok($ret, "add a queue no size limited");
is($err, "SUCCESS");

for my $i (1..$max_size) {
    $ret = memcached_set($memc, $q, $i);
    ok($ret, "set a item $i");
}

$ret = memcached_set($memc, $q, $max_size + 1);
ok($ret, "set a item exceed the max size limit when not enabled limit");

$ret = memcached_set($memc, $q, 't' x (4064-30-(length $q)));
ok($ret, "set a item exceed the max size limit when not enabled limit");


system("pkill memcacheq");
