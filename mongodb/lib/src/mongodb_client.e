note
	description: "[
		Object Representing MongoDB mongoc_client_t 
		It is an opaque type that provides access to a MongoDB server, replica set, or sharded cluster. 
		It maintains management of underlying sockets and routing to individual nodes based on mongoc_read_prefs_t or mongoc_write_concern_t.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name= Mongoc Client", "src=http://mongoc.org/libmongoc/current/mongoc_client_t.html", "protocol=uri"

class
	MONGODB_CLIENT

inherit

	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end
create
	make, make_by_pointer, make_from_uri

feature {NONE}-- Initialization

	make (a_uri: READABLE_STRING_GENERAL)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
		do
			memory_make
			mongoc_init
			new_mongoc_client (a_uri)
		end

	make_from_uri (a_uri: MONGODB_URI)
			-- Create a new client using `a_uri` prvided
		note
			eis: "name=mongoc_client_new_from_uri ", "src=https://mongoc.org/libmongoc/current/mongoc_client_new_from_uri.html", "protocol=uri"
		do
			memory_make
			mongoc_init
			make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_new_from_uri (a_uri.item))
			check success: item /= default_pointer end
		end

	new_mongoc_client (a_uri: READABLE_STRING_GENERAL)
			-- new mongodb client instance using the uri `a_uri'.
		note
			eis: "name=mongoc_client_new", "src=https://mongoc.org/libmongoc/current/mongoc_client_new.html", "protocol=uri"
		local
			c_string: C_STRING
		do
			create c_string.make (a_uri)
			make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_new (c_string.item))
			check success: item /= default_pointer end
		end

	new_from_uri_with_error (a_uri: MONGODB_URI)
			-- Creates a new client instance using the provided URI.
			-- Sets the error attribute if creation fails.
			--| TODO review the code and update to always use
			--| THIS FEATURE.
		local
			l_error: BSON_ERROR
			l_ptr: POINTER
		do
			create l_error.make
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_new_from_uri_with_error (a_uri.item, l_error.item)

			if l_ptr = default_pointer then
				error := l_error
			else
				error := Void
				make_by_pointer (l_ptr)
			end
		end

feature {NONE} -- Init

	mongoc_init
			-- Required to initialize libmongoc's internals.
		do
			{MONGODB_EXTERNALS}.c_mongoc_init
		end


feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_client_destroy (item)
			end
		end

feature -- Access

	uri: MONGODB_URI
			-- Fetches the mongoc_uri_t used to create the client.
		note
			EIS: "name=mongoc_client_get_uri", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_uri.html", "protocol=uri"

		do
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_uri (item))
		end

	collection (a_db: READABLE_STRING_GENERAL; a_collection: READABLE_STRING_GENERAL): MONGODB_COLLECTION
			-- a_db: The name of the database containing the collection.
			-- a_collection: The name of the collection.
			-- Note:
			--		Collections are automatically created on the MongoDB server upon insertion of the first document.
			--		There is no need to create a collection manually.
		note
			EIS: "name=mongoc_client_get_collection", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_collection.html", "protocol=uri"
		local
			c_db: C_STRING
			c_collection: C_STRING
			l_ptr:  POINTER
		do
			create c_db.make (a_db)
			create c_collection.make (a_collection)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_collection (item, c_db.item, c_collection.item)
			create Result.make_by_pointer (l_ptr)
		end

	database (a_dbname: READABLE_STRING_GENERAL): MONGODB_DATABASE
				-- Get a new database MONGODB_DATABASE for the database named `a_dbname'.
				-- Note
				-- 		Databases are automatically created on the MongoDB server upon insertion of the first document into a collection.
				--		There is no need to create a database manually.
		note
			EIS: "name=API get_database", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_database.html", "protocol=uri"
		local
			c_name: C_STRING
			l_ptr: POINTER
		do
			create c_name.make (a_dbname)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_database (item, c_name.item)
			create Result.make_by_pointer (l_ptr)
		end

	database_names (a_opts: detachable BSON): LIST [STRING]
	        -- Queries the MongoDB server for a list of known databases.
	        -- This is a retryable read operation that will be retried once upon transient errors.
	        -- `a_opts': Optional BSON document that may contain:
	        --   * sessionId: Client session ID for transactions
	        --   * serverId: To target a specific server
	        --   * Other options as specified in the listDatabases command
	    note
	        EIS: "name=mongoc_client_get_database_names_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_database_names_with_opts.html", "protocol=uri"
	    local
	        l_error: BSON_ERROR
	        l_ptr: POINTER
	        i: INTEGER
	        l_mgr: MANAGED_POINTER
	        l_opts: POINTER
	        l_res: INTEGER
	        l_cstring: C_STRING
	    do
	        if attached a_opts then
	            l_opts := a_opts.item
	        end
	        create l_error.make
	        create l_res.default_create
	        l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_database_names_with_opts (item, l_opts, l_error.item)

	        if l_ptr = default_pointer then
	            error := l_error
	            create {ARRAYED_LIST [STRING]} Result.make (0)
	        else
	            error := Void
	            l_res := {MONGODB_EXTERNALS}.c_mongoc_client_get_database_names_count (item, l_opts, l_error.item)
	            create l_mgr.make_from_pointer (l_ptr, l_res * c_sizeof (l_ptr))
	            create {ARRAYED_LIST [STRING]} Result.make (l_res)
	            from
	                i := 0
	            until
	                i = l_mgr.count
	            loop
	                create l_cstring.make_by_pointer (l_mgr.read_pointer (i))
	                Result.force (l_cstring.string)
	                i := i + c_sizeof (l_ptr)
	            end
	        end
	    ensure
	        result_not_void: Result /= Void
	        error_status_set: has_error implies error /= Void
	        success_status_set: not has_error implies error = Void
	    end

	default_database: detachable MONGODB_DATABASE
			-- Get the database named in the MongoDB connection URI, or VOID if the URI specifies none.
			-- Useful when you want to choose which database to use based only on the URI in a configuration file.
		note
			EIS: "name=mongoc_client_get_default_database", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_default_database.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_default_database (item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	find_databases_with_opts (a_opts: detachable BSON): MONGODB_CURSOR
			-- Fetches a cursor containing documents, each corresponding to a database on this MongoDB server.
			-- This is a retryable read operation that will be retried once upon transient errors.
			-- `a_opts': Optional BSON document that may contain:
			--   * sessionId: Client session ID for transactions
			--   * serverId: To target a specific server
			--   * Other options as specified in the listDatabases command
		note
			EIS: "name=mongoc_client_find_databases_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_find_databases_with_opts.html", "protocol=uri"
		local
			l_opts: POINTER
			l_ptr: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_find_databases_with_opts (item, l_opts)
			if l_ptr = default_pointer then
				-- Handle error case
				create Result.make (default_pointer)
				error := create {BSON_ERROR}.make
			else
				create Result.make (l_ptr)
				error := Void
			end
		ensure
			result_not_void: Result /= Void
		end

	read_concern: MONGODB_READ_CONCERN
				-- Retrieve the default read concern configured for the client instance.
				-- This Result should not be modified.
		note
			EIS: "name=mongoc_client_get_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_read_concern.html", "protocol=uri"
		do
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_read_concern (item))
		end

	read_preferences: MONGODB_READ_PREFERENCE
				-- Retrieves the default read preferences configured for the client instance.
				-- This result should not be modified
		note
			EIS: "name=mongoc_client_get_read_prefs", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_read_prefs.html", "protocol=uri"
		do
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_read_prefs (item))
		end

    write_concern: MONGODB_WRITE_CONCERN
            -- Get the write concern for this client
        note
        	eis: "name=mongoc_client_get_write_concern", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_write_concern.html", "protocol=uri"
        do
            create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_write_concern (item))
        end

	server_descriptions: LIST [MONGODB_SERVER_DESCRIPTION]
			-- Return an array of server descriptions or empty until the clients connects.
		note
			EIS: "name=mongoc_client_get_server_descriptions", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_server_descriptions.html", "protocol=uri"
		local
			l_size: INTEGER_64
			l_mgr: MANAGED_POINTER
			l_ptr: POINTER
			i: INTEGER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_server_descriptions (item, $l_size)
			create l_mgr.make_from_pointer (l_ptr, (l_size.as_integer_32)* c_sizeof (l_ptr))
			create {ARRAYED_LIST [MONGODB_SERVER_DESCRIPTION]} Result.make (l_size.as_integer_32)
			from
				i := 0
			until
				i = l_mgr.count
			loop
				Result.force (create {MONGODB_SERVER_DESCRIPTION}.make_by_pointer (l_mgr.read_pointer (i)))
				i := i + c_sizeof (l_ptr)
			end
		end

	get_crypt_shared_version: detachable STRING
			-- Obtain the version string of the crypt_shared that is loaded for auto-encryption.
			-- Returns Void if no crypt_shared library is loaded or auto-encryption is not loaded.
		note
			EIS: "name=mongoc_client_get_crypt_shared_version", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_crypt_shared_version.html", "protocol=uri"
		local
			l_ptr: POINTER
			l_c_string: C_STRING
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_crypt_shared_version (item)
			if l_ptr /= default_pointer then
				create l_c_string.make_by_pointer (l_ptr)
				Result := l_c_string.string
			end
		ensure
			result_void_or_not_empty: Result /= Void implies not Result.is_empty
		end


	get_handshake_description (a_server_id: NATURAL_32; a_opts: detachable BSON): detachable MONGODB_SERVER_DESCRIPTION
			-- Returns a description constructed from the initial handshake response to a server.
			-- Note: This is distinct from `get_server_description`. This returns a server description
			-- constructed from the connection handshake, which may differ from the server description
			-- constructed from monitoring.
			-- `a_server_id': The ID of the server to get the handshake description for
			-- `a_opts': Optional parameters for the operation
		note
			EIS: "name=mongoc_client_get_handshake_description", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_handshake_description.html", "protocol=uri"
		local
			l_error: BSON_ERROR
			l_ptr: POINTER
			l_opts: POINTER
		do
			create l_error.make
			if attached a_opts then
				l_opts := a_opts.item
			end

			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_handshake_description (
				item,			-- client
				a_server_id,	-- server_id
				l_opts,			-- opts
				l_error.item	-- error
			)

			if l_ptr = default_pointer then
				error := l_error
			else
				error := Void
				create Result.make_by_pointer (l_ptr)
			end
		ensure
			error_status_set: has_error implies error /= Void
			success_status_set: not has_error implies error = Void
			result_set_on_success: not has_error implies Result /= Void
		end

 	select_server (for_writes: BOOLEAN; prefs: detachable MONGODB_READ_PREFERENCE): detachable MONGODB_SERVER_DESCRIPTION
			-- Choose a server for an operation, according to the Server Selection Spec.
			-- `for_writes': Whether to choose a server suitable for writes or reads.
			-- `prefs': Optional read preferences. If for_writes is True, prefs must be Void.
			--         Otherwise, use prefs to customize server selection, or pass Void to use read preference PRIMARY.
			-- Returns: A server description that must be freed, or Void if no suitable server is found.
		note
			 EIS: "name=mongoc_client_select_server", "src=https://mongoc.org/libmongoc/current/mongoc_client_select_server.html", "protocol=uri"
		local
			l_prefs: POINTER
			l_error: BSON_ERROR
			l_ptr: POINTER
		do
			if attached prefs then
				l_prefs := prefs.item
			end

			create l_error.make
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_select_server (
				item,       -- client
				for_writes, -- for_writes
				l_prefs,    -- prefs
				l_error.item -- error
			)

			if l_ptr = default_pointer then
				create error.make_by_pointer (l_error.item)
			else
				error := Void
				create Result.make_by_pointer (l_ptr)
			end
		ensure
			error_status_set: has_error implies error /= Void
			success_status_set: not has_error implies error = Void
			result_set_on_success: not has_error implies Result /= Void
			result_void_on_error: has_error implies Result = Void
		end


feature -- Status

	server_status (a_read_prefs: detachable MONGODB_READ_PREFERENCE): BSON
			-- query the current server status, return a bson document.
		obsolete
			"Deprecated since version 1.10.0: Run the serverStatus command directly with read_command_with_opts() instead."
		local
			l_res: BOOLEAN
			l_reply: BSON
			l_error: BSON_ERROR
			l_prefs: POINTER
		do
			if attached a_read_prefs then
				l_prefs := a_read_prefs.item
			end
			create l_reply.make
			create l_error.make
			l_res :={MONGODB_EXTERNALS}.c_mongoc_client_get_server_status (item, l_prefs, l_reply.item, l_error.item)
			Result := l_reply
			if l_res then
				error := l_error
			else
				error := Void
			end
		end

	read_command_with_opts (a_db_name: READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE;
							a_opts: detachable BSON; a_reply: BSON; ): BOOLEAN
			-- Execute a command on the server, applying logic specific to read commands.
			-- This is a retryable read operation that will be retried once upon transient errors.
			-- `a_db_name': The name of the database to run the command on.
			-- `a_command': A BSON containing the command specification.
			-- `a_read_prefs': An optional read preferences.
			-- `a_opts': Optional BSON document that may contain:
			--   * readConcern: Read concern for the command
			--   * sessionId: Client session ID for transactions
			--   * collation: Text comparison options
			--   * serverId: To target a specific server
			-- `a_reply': Location for the resulting document.
		note
			EIS: "name=mongoc_client_read_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_read_command_with_opts.html", "protocol=uri"
		local
			c_db: C_STRING
			l_read_prefs: POINTER
			l_opts: POINTER
			l_error: BSON_ERROR
		do
			create c_db.make (a_db_name)
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make

			Result := {MONGODB_EXTERNALS}.c_mongoc_client_read_command_with_opts (
				item,           -- client
				c_db.item,     	-- db_name
				a_command.item, -- command
				l_read_prefs,   -- read_prefs
				l_opts,         -- opts
				a_reply.item,   -- reply
				l_error.item        	-- error
			)

			if not Result then
				create error.make_by_pointer (l_error.item)
			else
				error := Void
			end
		ensure
			error_status_set: has_error implies error /= Void
			success_status_set: not has_error implies error = Void
		end

	read_write_command_with_opts (a_db_name: READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE; a_opts: detachable BSON;
			a_reply: BSON)
			-- Execute a command on the server that both reads and writes.
			-- Note: The read_prefs parameter is ignored (included by mistake in libmongoc 1.5)
			-- `a_db_name': The name of the database to run the command on.
			-- `a_command': A BSON containing the command specification.
			-- `a_read_prefs': Ignored parameter (included for API compatibility).
			-- `a_opts': Optional BSON document that may contain:
			--   * readConcern: Read concern for the command
			--   * writeConcern: Write concern for the command
			--   * sessionId: Client session ID for transactions
			--   * collation: Text comparison options
			--   * serverId: To target a specific server
			-- `a_reply': Location for the resulting document.
			-- `a_error': Optional location for error information.
		note
			EIS: "name=mongoc_client_read_write_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_read_write_command_with_opts.html", "protocol=uri"
		local
			c_db: C_STRING
			l_read_prefs: POINTER
			l_opts: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			create c_db.make (a_db_name)
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_opts then
				l_opts := a_opts.item
			end

			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_read_write_command_with_opts (
				item,           -- client
				c_db.item,     	-- db_name
				a_command.item, -- command
				l_read_prefs,   -- read_prefs (ignored)
				l_opts,         -- opts
				a_reply.item,   -- reply
				l_error.item         -- error
			)

			if not l_res then
				create error.make_by_pointer (l_error.item)
			else
				error := Void
			end
		ensure
			error_status_set: has_error implies error /= Void
			success_status_set: not has_error implies error = Void
		end
feature -- Error

	set_error_api (a_version: INTEGER)
			-- Configure how the C Driver reports errors
			-- a_version: version of the error API, either MONGOC_ERROR_API_VERSION_LEGACY or MONGOC_ERROR_API_VERSION_2.
		note
			EIS: "name=mongoc_client_set_error_api", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_error_api.html", "protocol=uri"
		require
			valid_version: a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_2 or else a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_legacy
		local
			l_res: BOOLEAN
		do
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_error_api (item, a_version)
		end

feature -- Change Element

	set_read_concern (a_read_concern: MONGODB_READ_CONCERN)
			-- The default read concern is MONGOC_READ_CONCERN_LEVEL_LOCAL. This is the correct read concern for the great majority of applications.
			-- It is a programming error to call this function on a client from a mongoc_client_pool_t. For pooled clients, set the read concern with the MongoDB URI instead.
		note
			EIS: "name=mongoc_client_set_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_read_concern.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_client_set_read_concern (item, a_read_concern.item)
		end


	set_read_preference (a_read_pref: MONGODB_READ_PREFERENCE)
			-- Sets the default read preferences to use with future operations
			-- The global default is to read from the replica set primary.
		note
			EIS: "name=mongoc_client_set_read_prefs ", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_read_prefs.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_client_set_read_prefs (item, a_read_pref.item)
		end

	set_appname (a_name: READABLE_STRING_GENERAL)
			-- Sets the application name 'a_name' for this client.
			-- This string, along with other internal driver details, is sent to the server as part of the initial connection handshake ('isMaster').
			--'a_name': The application name, of length at most {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
		note
			EIS: "name=mongoc_client_set_appname", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_appname.html", "protocol=uri"
		require
			is_valid_length: a_name.count <= {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
		local
			c_name: C_STRING
			l_res: BOOLEAN
		do
			create c_name.make (a_name)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_appname (item, c_name.item)
			if not l_res then
					-- TODO improve error handling
				create error.make
			end
		end

	set_write_concern (a_write_concern: MONGODB_WRITE_CONCERN)
			-- Set the write concern for this client
		note
			eis: "name=", "src=https://mongoc.org/libmongoc/current/mongoc_client_set_write_concern.html", "protocl=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_client_set_write_concern (item, a_write_concern.item)
		end

	reset
			-- Reset the client after forking to prevent resource cleanup interference.
			-- Note: This method:
			-- * Clears the session pool without sending endSessions
			-- * Increments internal generation counter
			-- * Prevents cursors from previous generations from issuing killCursors commands
			-- * Invalidates client sessions from previous generations
		note
			 EIS: "name=mongoc_client_reset", "src=http://mongoc.org/libmongoc/current/mongoc_client_reset.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_client_reset (item)
		end

	set_server_api (a_api: MONGODB_SERVER_API)
			-- Set the API version to use for this client.
			-- Note: Once the API version is set, it cannot be changed to a new value.
			-- Returns: True if the API version was successfully set, False otherwise.
		require
			api_not_void: a_api /= Void
		local
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_server_api (
				item,        -- client
				a_api.item,  -- api
				l_error.item -- error
			)

			if not l_res then
				create error.make_by_pointer (l_error.item)
			else
				error := Void
			end
		end

feature -- Command

    ping (a_db: READABLE_STRING_GENERAL): BOOLEAN
            -- Test if server is responsive
        local
            l_command: BSON
            l_reply: BSON
        do
            create l_command.make_from_json ("{ping: 1}")
            create l_reply.make
            command_simple (a_db, l_command, Void, l_reply)
            Result := not has_error
        end

	command_simple (a_db:READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE; a_reply: BSON)
			-- This is a simplified interface to mongoc_client_command(). It returns the first document from the result cursor into reply.
			-- The client’s read preference, read concern, and write concern are not applied to the command.
			-- 'a_db': The name of the database to run the command on.
			-- 'a_command': A bson_t containing the command specification.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t. Otherwise, the command uses mode MONGOC_READ_PRIMARY.
			-- 'reply': A location for the resulting document.
		note
			EIS: "name=mongoc_client_command_simple", "src=http://mongoc.org/libmongoc/current/mongoc_client_command_simple.html", "protocol=uri"
		local
			c_db: C_STRING
			l_res: BOOLEAN
			l_read_prefs:  POINTER
			l_error: BSON
		do
			create c_db.make (a_db)

			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end

			create l_error.make

			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_command_simple (item, c_db.item, a_command.item, l_read_prefs, a_reply.item, l_error.item)
			if not l_res then
				create error.make_by_pointer (l_error.item)
			end
		end

	command_with_opts (a_db_name: READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE; a_opts:detachable BSON;  a_reply: BSON; a_error: detachable BSON_ERROR)
			-- Execute a command on the server, interpreting opts according to the MongoDB server version.
			-- 'a_db_name': The name of the database to run the command on.
			-- 'a_command': A bson_t containing the command specification.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t.
			-- 'a_opts': A bson_t containing additional options.
			-- 'a_reply': A location for the resulting document.
			-- 'a_error': An optional location for a bson_error_t or NULL.	
		note
			EIS: "name=mongoc_client_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_command_with_opts.html", "protocol=uri"
		local
			c_db: C_STRING
			l_read_prefs: POINTER
			l_opts: POINTER
			l_error: POINTER
			l_res: BOOLEAN
		do
			create c_db.make (a_db_name)
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_error then
				l_error := a_error.item
			end
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_command_with_opts (item, c_db.item, a_command.item, l_read_prefs, l_opts, a_reply.item, l_error)
		end

feature -- Session

	start_session (a_opts: detachable MONGODB_SESSION_OPT): MONGODB_CLIENT_SESSION
		local
			l_opts: POINTER
			l_error: BSON
			l_ptr: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_start_session (item, l_opts, l_error.item )
				-- TODO check if there was an error. check l_error.
			create Result.make_by_pointer (l_ptr)
		end

feature {NONE} -- Measurement

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_client_t *);"
		end

	c_sizeof (ptr: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof ($ptr)"
		end

	c_mongoc_client_destroy (a_client: POINTER)
		note
			eis: "name=mongoc_client_destroy", "src=https://mongoc.org/libmongoc/current/mongoc_client_destroy.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_destroy ((mongoc_client_t *)$a_client);"
		end


end
