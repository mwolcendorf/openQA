# Copyright (C) 2014 SUSE Linux Products GmbH
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

package OpenQA::Test::Case;

use OpenQA::Test::Database;
use OpenQA::Test::Testresults;
use Mojo::Base -base;
use Date::Format qw/time2str/;

sub init_data {
    # This should result in the 't' directory, even if $0 is in a subdirectory
    my ($tdirname) = $0 =~ qr/((.*\/t\/|^t\/)).+$/;
    my $schema = OpenQA::Test::Database->new->create();

    # ARGL, we can't fake the current time and the db manages
    # t_started so we have to override it manually
    my $r = $schema->resultset("Jobs")->search({ id => 99937 })->update({
            t_created => time2str('%Y-%m-%d %H:%M:%S', time-540000, 'UTC'),  # 150 hours ago;
    });

    OpenQA::Test::Testresults->new->create(directory => $tdirname.'testresults');
}

1;