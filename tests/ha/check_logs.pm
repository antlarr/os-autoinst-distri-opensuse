# SUSE's openQA tests
#
# Copyright (c) 2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# G-Summary: Add HA tests
#    - boot ha_support_server with dhcp/dns/ntp/iscsi services
#    - configure ntp/iscsi/watchdog on nodes
#    - create/join cluster using ha_cluster_init/join
#    - create shared OCFS2 and check that it's really shared
#    - check cluster status using crm_mon
#    - fence a node and check that it's really fenced
#    - grep /var/log to find segfaults at the end
# G-Maintainer: Denis Zyuzin <dzyuzin@suse.com>

use base "hacluster";
use strict;
use testapi;
use autotest;
use lockapi;

sub run() {
    my $self = shift;
    barrier_wait("FENCING_DONE_" . $self->cluster_name);
    select_console 'root-console';

    script_run "hb_report -f 2014 hb_report", 120;
    upload_logs "hb_report.tar.bz2";
    type_string "echo segfaults=`grep -sR segfault /var/log | wc -l` > /dev/$serialdev\n";
    die "segfault occured" unless wait_serial "segfaults=0", 60;
    barrier_wait("LOGS_CHECKED_" . $self->cluster_name);
}

sub test_flags {
    return {fatal => 1};
}

1;
