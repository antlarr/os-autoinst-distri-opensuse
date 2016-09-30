# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# G-Summary: Rework the tests layout.
# G-Maintainer: Alberto Planas <aplanas@suse.com>

use base "y2logsstep";
use strict;
use testapi;
use windows_utils;

sub run() {
    my $self = shift;

    assert_screen "grub-reboot-windows", 125;

    send_key "down";
    send_key "down";
    send_key "ret";

    wait_boot_windows;
}

1;
# vim: set sw=4 et:
