Puppet::Type.newtype(:domain) do
    @doc = "Manage participation in an Active Directory Domain"

    ensurable

    newparam(:domainname, :namevar => true) do
        desc "The name of the domain"
    end

    newparam(:username) do
        desc "The username of a user that has permissions to added machines to the domain"
    end

    newparam(:password) do
        desc "The password of the user"
    end

    newproperty(:shortlogin) do
        desc "If no domain is specified logging in, prepend the default domain name"
        newvalues(:true,:false)
        defaultto :true
    end

    newproperty(:domainseparator) do
        desc "The character to use to seperate the domain from the username. Defaults to a plus character"
        defaultto "+"
    end

    newproperty(:requiredgroup) do
        desc "AD Group that must be a member of to login"
        defaultto ""
        validate do |value|
            unless value =~ /^\w+/
                raise ArgumentError, "%s is not a valid group name" % value
            end
        end
    end
    
    newproperty(:loginshell) do
    	desc "The Shell that is assigned to AD Logins"
    	defaultto "/bin/bash"
    end
end
