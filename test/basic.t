#!/usr/bin/env perl

use strict;
use warnings;

use Memcached::libmemcached qw(/^memcached/);

use Test::More 'no_plan';

my $memc = memcached_create();
memcached_server_add($memc, "localhost", 22201);

my $q = "test" . time;
#my $q = "test";

my $ret;
my $err;
my $max_size = 10;

$ret = memcached_add($memc, $q, "xaf");
$err = $memc->errstr;
ok(!(defined $ret), "add a queue no max size");
is($err, "NOT STORED");


$ret = memcached_add($memc, $q, $max_size);
$err = $memc->errstr;
ok($ret, "add a queue");
is($err, "SUCCESS");

$ret = memcached_add($memc, $q, 100);
$err = $memc->errstr;
ok(!(defined $ret), "add a queue again");
is($err, "NOT STORED");

for my $i (1..$max_size) {
    $ret = memcached_set($memc, $q, $i);
    ok($ret, "set a item $i");
}

$ret = memcached_set($memc, $q, $max_size + 1);
ok(!$ret, "set a item will exceed the limit of max size");

for my $i (1..$max_size) {
    $ret = memcached_get($memc, $q);
    is($ret, $i, "get item $i");
}
$ret = memcached_get($memc, $q);
ok(!$ret, "get a item will exceed the limit of max size");

my $q2 = "test-q2" . time;
$max_size = 5;

$ret = memcached_add($memc, $q2, "xaf");
$err = $memc->errstr;
ok(!(defined $ret), "add a queue no max size");
is($err, "NOT STORED");


$ret = memcached_add($memc, $q2, $max_size);
$err = $memc->errstr;
ok($ret, "add a queue");
is($err, "SUCCESS");

$ret = memcached_add($memc, $q2, 100);
$err = $memc->errstr;
ok(!(defined $ret), "add a queue again");
is($err, "NOT STORED");

for my $i (1..$max_size) {
    $ret = memcached_set($memc, $q2, $i);
    ok($ret, "set a item $i");
}

$ret = memcached_set($memc, $q2, $max_size + 1);
ok(!$ret, "set a item will exceed the limit of max size");

for my $i (1..$max_size) {
    $ret = memcached_get($memc, $q2);
    is($ret, $i, "get item $i");
}
$ret = memcached_get($memc, $q2);
ok(!$ret, "get a item will exceed the limit of max size");

ok(memcached_delete($memc, $q), "delete queue 1");
ok(memcached_delete($memc, $q2), "delete queue 2");
ok(!memcached_delete($memc, $q2), "delete queue 2 again");


