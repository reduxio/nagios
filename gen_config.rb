#!/usr/bin/ruby
# ------------------------------------------------------------------------------
# gen_config.rb - creates a Nagios cfg file for multiple Reduxio systems.
#
# Usage: ./gen_config
#
# Edit the HOSTS hash to include your specific Reduxio host details.
# The result will be a 'reduxio_gen.cfg' which you should copy to the desired
# conf dir on Nagios.
# ------------------------------------------------------------------------------
# Copyright (C) 2016  Reduxio Systems, www.reduxio.com
# See all of our documentation in:
#       http://www.reduxio.com/resources
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ------------------------------------------------------------------------------
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ------------------------------------------------------------------------------
#                               Version Notes
# ------------------------------------------------------------------------------
# Version : 1.0.0
# Date    : November 22 2016
# ------------------------------------------------------------------------------
# 

CHECK_INTERVAL = 60

HOSTS =  [
        {"name" => "nitro", "address" => "nitro-mgmt.il.reduxio", "user" => "rdxadmin" , "pass" => "admin"}, 
        {"name" => "omega", "address" => "omega-mgmt.il.reduxio", "user" => "rdxadmin" , "pass" => "admin"},
        {"name" => "hodor", "address" => "hodor-mgmt.il.reduxio", "user" => "rdxadmin" , "pass" => "admin"},
        {"name" => "debug", "address" => "debug-mgmt.il.reduxio", "user" => "rdxadmin" , "pass" => "admin"},
        {"name" => "ping" , "address" => "ping-mgmt.il.reduxio" , "user" => "rdxadmin" , "pass" => "admin"}
]

command = "define command{
        command_name reduxio_status
        command_line $USER1$/check_reduxio.pl --host $HOSTADDRESS$ --username $ARG1$ --password $ARG2$
}"

host_tmpl = "define host{
        use                     linux-server
        host_name               %s
        alias                   %s
        address                 %s
}
"

service_tmpl = "define service{
        use                             generic-service         ; Name of service template to use
        host_name                       %s
        service_description             Reduxio Status of %s
        check_command                   reduxio_status!%s!%s
        check_interval                  #{CHECK_INTERVAL}
}"



File.open("reduxio_gen.cfg", 'w') { |file| 
	file.write(command + "\n\n\n")

	HOSTS.each do |rdx_host|
                name    = rdx_host["name"]
                address = rdx_host["address"]
                user    = rdx_host["user"]
                pass    = rdx_host["pass"]

		file.write(host_tmpl % [name,name, address])
		file.write("\n")
		file.write(service_tmpl % [name, name, user, pass])
		file.write("\n\n\n")
	end 
}

