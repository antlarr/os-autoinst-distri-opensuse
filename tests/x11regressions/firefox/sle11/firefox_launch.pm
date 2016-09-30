# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.


##################################################
# Written by:   Xudong Zhang <xdzhang@suse.com>
# Case:         1248965
# Description:  Launch firefox, click "know your right" quit and relaunch
# This case is available only when you run firefox the first time
##################################################

# G-Summary: Restore SLE11 cases to sub-directory, remove main.pm lines because no openSUSE cases.
# G-Maintainer: wnereiz <wnereiz@gmail.com>

use strict;
use base "x11regressiontest";
use testapi;

sub run() {
    my $self = shift;
    mouse_hide();
    x11_start_program("firefox");
    assert_screen "start-firefox", 5;
    if (get_var("UPGRADE")) { send_key "alt-d"; wait_idle; }    # dont check for updated plugins
    if (get_var("DESKTOP") =~ /xfce|lxde/i) {
        send_key "ret";                                         # confirm default browser setting popup
        wait_idle;
    }

    check_screen "firefox_know-rights", 3;
    send_key "alt-k";
    sleep 1;                                                    #click know your rights
    check_screen "firefox_about-rights", 3;
    send_key "ctrl-w";
    sleep 1;

    send_key "alt-f4";
    sleep 2;
    send_key "ret";
    sleep 2;                                                    # confirm "save&quit"
}

1;
# vim: set sw=4 et:
