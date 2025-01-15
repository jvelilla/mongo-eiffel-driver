note
    description: "[
        Object representing mongoc_ssl_opt_t structure.
        This structure is used to set the TLS options for a mongoc_client_t or mongoc_client_pool_t.
    ]"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=mongoc_ssl_opt_t", "src=http://mongoc.org/libmongoc/current/mongoc_ssl_opt_t.html", "protocol=uri"

class
    MONGODB_SSL_OPTS

inherit
    MONGODB_WRAPPER_BASE
        rename
            make as memory_make
        end

create
    make, make_by_pointer

feature {NONE} -- Initialization

    make
            -- Initialize SSL options with default values.
        do
            memory_make
        end

feature -- Access

	get_default: MONGODB_SSL_OPTS
			-- default SSL options for the process.
			-- This should not be modified or freed.
		do
	  		create Result.make_by_pointer(c_mongoc_ssl_opt_get_default)
		end

    pem_file: detachable STRING_8
            -- Path to the client certificate file in PEM format.
        local
            c_string: C_STRING
        do
            create c_string.make_by_pointer (c_mongoc_ssl_opt_get_pem_file (item))
            if c_string.item /= default_pointer then
                Result := c_string.string
            end
        end

    pem_pwd: detachable STRING_8
            -- Password for the client certificate PEM file.
        local
            c_string: C_STRING
        do
            create c_string.make_by_pointer (c_mongoc_ssl_opt_get_pem_pwd (item))
            if c_string.item /= default_pointer then
                Result := c_string.string
            end
        end

    ca_file: detachable STRING_8
            -- Path to file containing concatenated certificate authority certificates.
        local
            c_string: C_STRING
        do
            create c_string.make_by_pointer (c_mongoc_ssl_opt_get_ca_file (item))
            if c_string.item /= default_pointer then
                Result := c_string.string
            end
        end

    ca_dir: detachable STRING_8
            -- Path to directory containing individual certificate authority certificates.
        local
            c_string: C_STRING
        do
            create c_string.make_by_pointer (c_mongoc_ssl_opt_get_ca_dir (item))
            if c_string.item /= default_pointer then
                Result := c_string.string
            end
        end

    crl_file: detachable STRING_8
            -- Path to file containing certificate revocation list.
        local
            c_string: C_STRING
        do
            create c_string.make_by_pointer (c_mongoc_ssl_opt_get_crl_file (item))
            if c_string.item /= default_pointer then
                Result := c_string.string
            end
        end

    weak_cert_validation: BOOLEAN
            -- Relax the constraints for validating the server's certificate.
        do
            Result := c_mongoc_ssl_opt_get_weak_cert_validation (item)
        end

    allow_invalid_hostname: BOOLEAN
            -- Disable hostname validation of the server's certificate.
        do
            Result := c_mongoc_ssl_opt_get_allow_invalid_hostname (item)
        end

feature -- Element Change

    set_pem_file (a_file: READABLE_STRING_8)
            -- Set the path to the client certificate file in PEM format.
        require
            a_file_not_void: a_file /= Void
        local
            c_string: C_STRING
        do
            create c_string.make (a_file)
            c_mongoc_ssl_opt_set_pem_file (item, c_string.item)
        end

    set_pem_pwd (a_pwd: READABLE_STRING_8)
            -- Set the password for the client certificate PEM file.
        require
            a_pwd_not_void: a_pwd /= Void
        local
            c_string: C_STRING
        do
            create c_string.make (a_pwd)
            c_mongoc_ssl_opt_set_pem_pwd (item, c_string.item)
        end

    set_ca_file (a_file: READABLE_STRING_8)
            -- Set the path to file containing concatenated certificate authority certificates.
        require
            a_file_not_void: a_file /= Void
        local
            c_string: C_STRING
        do
            create c_string.make (a_file)
            c_mongoc_ssl_opt_set_ca_file (item, c_string.item)
        end

    set_ca_dir (a_dir: READABLE_STRING_8)
            -- Set the path to directory containing individual certificate authority certificates.
        require
            a_dir_not_void: a_dir /= Void
        local
            c_string: C_STRING
        do
            create c_string.make (a_dir)
            c_mongoc_ssl_opt_set_ca_dir (item, c_string.item)
        end

    set_crl_file (a_file: READABLE_STRING_8)
            -- Set the path to file containing certificate revocation list.
        require
            a_file_not_void: a_file /= Void
        local
            c_string: C_STRING
        do
            create c_string.make (a_file)
            c_mongoc_ssl_opt_set_crl_file (item, c_string.item)
        end

    set_weak_cert_validation (a_value: BOOLEAN)
            -- Set whether to relax the constraints for validating the server's certificate.
        do
            c_mongoc_ssl_opt_set_weak_cert_validation (item, a_value)
        end

    set_allow_invalid_hostname (a_value: BOOLEAN)
            -- Set whether to disable hostname validation of the server's certificate.
        do
            c_mongoc_ssl_opt_set_allow_invalid_hostname (item, a_value)
        end

feature -- Removal

	dispose
		do
				-- do nothing
		end

feature -- Measurement

    structure_size: INTEGER
            -- Size to allocate (in bytes)
        do
            Result := struct_size
        end


feature {NONE} -- Implementation

    struct_size: INTEGER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return sizeof(mongoc_ssl_opt_t);"
        end


    feature -- SSL Options

    c_mongoc_ssl_opt_get_default: POINTER
            -- Get the default SSL options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (void *)mongoc_ssl_opt_get_default();"
        end

    c_mongoc_ssl_opt_get_pem_file (opts: POINTER): POINTER
            -- Get the path to the client certificate file in PEM format
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return ((mongoc_ssl_opt_t *)$opts)->pem_file;"
        end

    c_mongoc_ssl_opt_set_pem_file (opts: POINTER; value: POINTER)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "((mongoc_ssl_opt_t *)$opts)->pem_file = (const char *)$value;"
        end

    c_mongoc_ssl_opt_get_weak_cert_validation (opts: POINTER): BOOLEAN
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return ((mongoc_ssl_opt_t *)$opts)->weak_cert_validation;"
        end

    c_mongoc_ssl_opt_set_weak_cert_validation (opts: POINTER; value: BOOLEAN)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "((mongoc_ssl_opt_t *)$opts)->weak_cert_validation = (bool)$value;"
        end

    c_mongoc_ssl_opt_get_allow_invalid_hostname (opts: POINTER): BOOLEAN
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return ((mongoc_ssl_opt_t *)$opts)->allow_invalid_hostname;"
        end

    c_mongoc_ssl_opt_set_allow_invalid_hostname (opts: POINTER; value: BOOLEAN)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "((mongoc_ssl_opt_t *)$opts)->allow_invalid_hostname = (bool)$value;"
        end

    c_mongoc_ssl_opt_get_pem_pwd (opts: POINTER): POINTER
            -- Get the password for the client certificate PEM file
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return ((mongoc_ssl_opt_t *)$opts)->pem_pwd;"
        end

    c_mongoc_ssl_opt_set_pem_pwd (opts: POINTER; value: POINTER)
            -- Set the password for the client certificate PEM file
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "((mongoc_ssl_opt_t *)$opts)->pem_pwd = (const char *)$value;"
        end

    c_mongoc_ssl_opt_get_ca_file (opts: POINTER): POINTER
            -- Get the path to file containing concatenated certificate authority certificates
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return ((mongoc_ssl_opt_t *)$opts)->ca_file;"
        end

    c_mongoc_ssl_opt_set_ca_file (opts: POINTER; value: POINTER)
            -- Set the path to file containing concatenated certificate authority certificates
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "((mongoc_ssl_opt_t *)$opts)->ca_file = (const char *)$value;"
        end

    c_mongoc_ssl_opt_get_ca_dir (opts: POINTER): POINTER
            -- Get the path to directory containing individual certificate authority certificates
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return ((mongoc_ssl_opt_t *)$opts)->ca_dir;"
        end

    c_mongoc_ssl_opt_set_ca_dir (opts: POINTER; value: POINTER)
            -- Set the path to directory containing individual certificate authority certificates
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "((mongoc_ssl_opt_t *)$opts)->ca_dir = (const char *)$value;"
        end

    c_mongoc_ssl_opt_get_crl_file (opts: POINTER): POINTER
            -- Get the path to file containing certificate revocation list
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return ((mongoc_ssl_opt_t *)$opts)->crl_file;"
        end

    c_mongoc_ssl_opt_set_crl_file (opts: POINTER; value: POINTER)
            -- Set the path to file containing certificate revocation list
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "((mongoc_ssl_opt_t *)$opts)->crl_file = (const char *)$value;"
        end

end
