Puppet::Type.type(:domain).provide :pbis do
    desc "Manages AD Domain membership"

    #commands :config => '/opt/pbis/bin/config'

    def create
       system "domainjoin-cli join '#{@resource[:domainname]}' '#{@resource[:username]}' '#{@resource[:password]}'"
    end

    def destroy
       system "domainjoin-cli leave '#{@resource[:username]}' '#{@resource[:password]}'"
    end

    def exists?
        result = `domainjoin-cli query | grep Domain | cut -d' ' -f3  | tr [A-Z] [a-z]`.strip
        debug "Current Domain: %s" % result
        if(result == @resource[:domainname])
            return true
        else
            return false
        end
    end

    def shortlogin
        result = `/opt/pbis/bin/config --show AssumeDefaultDomain | head -2 | tail -1`.strip
        debug "AssumeDefaultDomain: %s" % result
        if(result == "true")
            return :true
        else
            return :false
        end
    end

    def shortlogin=(value)
        system "/opt/pbis/bin/config AssumeDefaultDomain %s" % value
    end

    def requiredgroup
        result = `/opt/pbis/bin/config --show RequireMembershipOf | head -2 | tail -1`.strip
        debug "RequireMembershipOf: %s" % result
        return result
    end

    def requiredgroup=(value)
        system '/opt/pbis/bin/config RequireMembershipOf %s' % value
    end

    def domainseparator
        result = `/opt/pbis/bin/config --show DomainSeparator | head -2 | tail -1`.strip
        debug "DomainSeparator: %s" % result
        return result
    end

    def domainseparator=(value)
        system '/opt/pbis/bin/config DomainSeparator %s' % value
    end
    
    def loginshell
    	result = `/opt/pbis/bin/config --show LoginShellTemplate | head -2 | tail -1`.strip
    	return result
    end
    
    def loginshell=(value)
    	system '/opt/pbis/bin/config LoginShellTemplate %s' % value
    end
end
