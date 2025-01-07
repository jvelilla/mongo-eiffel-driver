note
	description: "Summary description for {MONGODB_EXTERNALS}."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Mongodb API", "src=http://mongoc.org/libmongoc/current/api.html", "protocol=uri"


class
	MONGODB_EXTERNALS

feature -- Init

	c_mongoc_init
			-- Required to initialize libmongoc's internals
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_init();"
		end

feature -- Read Concern Levels		

	MONGOC_READ_CONCERN_LEVEL_LOCAL: STRING = "local"
			-- #define MONGOC_READ_CONCERN_LEVEL_LOCAL "local".

	MONGOC_READ_CONCERN_LEVEL_MAJORITY: STRING = "majority"
			-- #define MONGOC_READ_CONCERN_LEVEL_MAJORITY "majority".

	MONGOC_READ_CONCERN_LEVEL_LINEARIZABLE: STRING = "linearizable"
			-- #define MONGOC_READ_CONCERN_LEVEL_LINEARIZABLE "linearizable"

feature -- Error

	MONGOC_ERROR_API_VERSION_LEGACY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_LEGACY"
		end

	MONGOC_ERROR_API_VERSION_2: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_2"
		end

	MONGOC_HANDSHAKE_APPNAME_MAX: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_HANDSHAKE_APPNAME_MAX"
		end

feature -- Read Preference Modes

	MONGOC_READ_PRIMARY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_PRIMARY"
		end

	MONGOC_READ_SECONDARY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_SECONDARY"
		end

	MONGOC_READ_PRIMARY_PREFERRED: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_PRIMARY_PREFERRED"
		end

	MONGOC_READ_SECONDARY_PREFERRED: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_SECONDARY_PREFERRED"
		end

	MONGOC_READ_NEAREST: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_NEAREST"
		end

	MONGOC_NO_MAX_STALENESS: INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_NO_MAX_STALENESS"
		end


Feature -- Mongo Query Flags

	MONGOC_QUERY_NONE: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_NONE"
		end

	MONGOC_QUERY_TAILABLE_CURSOR: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_TAILABLE_CURSOR"
		end

	MONGOC_QUERY_SLAVE_OK: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_SLAVE_OK"
		end

	MONGOC_QUERY_OPLOG_REPLAY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_OPLOG_REPLAY"
		end

	MONGOC_QUERY_NO_CURSOR_TIMEOUT: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_NO_CURSOR_TIMEOUT"
		end

	MONGOC_QUERY_AWAIT_DATA: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_AWAIT_DATA"
		end

	MONGOC_QUERY_EXHAUST: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_EXHAUST"
		end

	MONGOC_QUERY_PARTIAL: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_PARTIAL"
		end

feature -- Client

	c_mongoc_client_new (a_uri: POINTER): POINTER
			-- Create a new client instance with uri `a_uri'.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_new ((const char *)$a_uri);"
		end

	c_mongoc_client_new_from_uri (a_uri: POINTER): POINTER
			-- Create a new client instance with uri `a_uri'.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_new_from_uri ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_client_set_appname (a_client: POINTER; a_appname: POINTER): BOOLEAN
			-- Sets the application name for this client.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_client_set_appname ((mongoc_client_t *)$a_client, (const char *)$a_appname);"
		end

	c_mongoc_client_get_database (a_client: POINTER; a_name: POINTER): POINTER
			-- Get a newly allocated mongoc_database_t for the database named name.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_database ((mongoc_client_t *)$a_client, (const char *)$a_name);"
		end

	c_mongoc_client_get_default_database (a_client: POINTER): POINTER
			-- Get the database named in the MongoDB connection URI, or NULL if the URI specifies none.
			-- Useful when you want to choose which database to use based only on the URI in a configuration file.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_default_database ((mongoc_client_t*)$a_client);"
		end

	c_mongoc_client_get_collection (a_client: POINTER; a_db: POINTER; a_collection: POINTER): POINTER
			-- Get a newly allocated mongoc_collection_t for the collection named collection in the database named db.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_get_collection ((mongoc_client_t *)$a_client,
				                              (const char *)$a_db,
				                              (const char *)$a_collection);
			]"
		end

	c_mongoc_client_command_simple (a_client: POINTER; a_dbname: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN) mongoc_client_command_simple ((mongoc_client_t *)$a_client,
				                              (const char *)$a_dbname,
				                              (const bson_t *)$a_command,
				                              (const mongoc_read_prefs_t *)$a_read_prefs,
				                              (bson_t *)$a_reply,
				                              (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_client_set_error_api (a_client: POINTER; a_version: INTEGER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_set_error_api ((mongoc_client_t *)$a_client, (int32_t)$a_version);"
		end

	c_mongoc_client_command_with_opts (a_client: POINTER; a_db_name: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN)	mongoc_client_command_with_opts (
											   (mongoc_client_t *)$a_client,
											   (const char *)$a_db_name,
											   (const bson_t *)$a_command,
											   (const mongoc_read_prefs_t *)$a_read_prefs,
											   (const bson_t *)$a_opts,
											   (bson_t *)$a_reply,
											   (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_client_get_database_names_with_opts (a_client: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
					   char **strv;
					   strv = mongoc_client_get_database_names_with_opts ($a_client, $a_opts, $a_error);
				 	   return strv;
			]"
		end

	c_mongoc_client_get_database_names_count (a_client: POINTER; a_opts: POINTER; a_error: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				char **strv;
				strv = mongoc_client_get_database_names_with_opts ($a_client, $a_opts, $a_error);
				int i;
				for (i = 0; strv[i]; i++);
				return i;
			]"
		end

	c_mongoc_client_get_uri (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_get_uri ((const mongoc_client_t *)$a_client);
			]"
		end

	c_mongoc_client_get_server_status (a_client: POINTER; a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN) mongoc_client_get_server_status ((mongoc_client_t *)$a_client,
				                                 (mongoc_read_prefs_t *)$a_read_prefs,
				                                 (bson_t *)$a_reply,
				                                 (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_client_find_databases_with_opts (a_client: POINTER; a_opts: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_find_databases_with_opts ((mongoc_client_t *)$a_client, (const bson_t *)$a_opts);

			]"
		end

	c_mongoc_client_get_read_concern (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_get_read_concern ((const mongoc_client_t *)$a_client);

			]"
		end


	c_mongoc_client_get_read_prefs (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_get_read_prefs ((const mongoc_client_t *)$a_client);

			]"
		end


	c_mongoc_client_set_read_concern (a_client: POINTER; a_read_concern: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								mongoc_client_set_read_concern ((mongoc_client_t *)$a_client, (const mongoc_read_concern_t *)$a_read_concern);

			]"
		end


	c_mongoc_client_set_read_prefs (a_client: POINTER; a_read_prefs:POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								mongoc_client_set_read_prefs ((mongoc_client_t *)$a_client, (const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_client_get_server_descriptions (a_client: POINTER; a_size: TYPED_POINTER [INTEGER_64]): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
						size_t i, n;
						mongoc_server_description_t ** res;
						res = mongoc_client_get_server_descriptions ((const mongoc_client_t *)$a_client, &n);
						$a_size = n;
						return res;
			]"
		end

	c_mongoc_client_start_session (a_client: POINTER; a_opts: POINTER; a_error:POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
						return mongoc_client_start_session ((mongoc_client_t *)$a_client, (mongoc_session_opt_t *)$a_opts, (bson_error_t *)$a_error);

			]"
		end

	c_mongoc_client_get_write_concern (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_write_concern ((const mongoc_client_t *)$a_client);"
		end

	c_mongoc_client_set_write_concern (a_client: POINTER; a_write_concern: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_set_write_concern ((mongoc_client_t *)$a_client, (const mongoc_write_concern_t *)$a_write_concern);"
		end

	c_mongoc_client_get_max_message_size (a_client: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_max_message_size ((const mongoc_client_t *)$a_client);"
		end

	c_mongoc_client_select_server (a_client: POINTER; a_for_writes: BOOLEAN; a_prefs: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_select_server ((mongoc_client_t *)$a_client, (bool)$a_for_writes, (const mongoc_read_prefs_t *)$a_prefs, (bson_error_t *)$a_error);"
		end

feature -- Mongo Collection

	c_mongoc_collection_insert_one (a_collection: POINTER; a_document: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN) mongoc_collection_insert_one ((mongoc_collection_t *)$a_collection,
				                              (const bson_t *)$a_document,
				                              (const bson_t *)$a_opts,
				                              (bson_t *)$a_reply,
				                              (bson_error_t *)$a_error);
			]"
		end


	c_mongoc_collection_insert_many (a_collection: POINTER; a_documents: POINTER; a_val: INTEGER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
			   	return	mongoc_collection_insert_many ((mongoc_collection_t *)$a_collection,
                               (const bson_t **)$a_documents,
                               (size_t) $a_val,
                               (const bson_t *)$a_opts,
                               (bson_t *)$a_reply,
                               (bson_error_t *)$a_error);
			]"
		end


	c_mongoc_collection_find_with_opts (a_collection: POINTER; a_filter: POINTER; a_opts: POINTER; a_read_prefs: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_collection_find_with_opts ((mongoc_collection_t *)$a_collection,
				                                  (const bson_t *)$a_filter,
				                                  (const bson_t *)$a_opts,
				                                  (const mongoc_read_prefs_t *)$a_read_prefs)
			]"
		end

	c_mongoc_collection_update_one (a_collection: POINTER; a_selector: POINTER; a_update: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_collection_update_one ((mongoc_collection_t *)$a_collection,
				                             (const bson_t *)$a_selector,
				                             (const bson_t *)$a_update,
				                             (const bson_t *)$a_opts,
				                             (bson_t *)$a_reply,
				                             (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_collection_delete_one (a_collection: POINTER; a_selector: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN)  mongoc_collection_delete_one ((mongoc_collection_t *)$a_collection,
				                              (const bson_t *)$a_selector,
				                              (const bson_t *)$a_opts,
				                              (bson_t *)$a_reply,
				                              (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_collection_count (a_collection: POINTER; a_flags: INTEGER; a_query: POINTER; a_skip: INTEGER_64; a_limit: INTEGER_64; a_read_prefs: POINTER; a_error: POINTER): INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
					return (EIF_INTEGER_64)
					mongoc_collection_count ((mongoc_collection_t *)$a_collection,
				                         (mongoc_query_flags_t)$a_flags,
				                         (const bson_t *)$a_query,
				                         (int64_t)$a_skip,
				                         (int64_t)$a_limit,
				                         (const mongoc_read_prefs_t *)$a_read_prefs,
				                         (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_collection_drop_with_opts (a_collection: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN)  mongoc_collection_drop_with_opts ((mongoc_collection_t *)$a_collection,
				                                  (bson_t *)$a_opts,
				                                  (bson_error_t *)$a_error);
			]"
		end



	c_mongoc_collection_aggregate (a_collection: POINTER; a_flags: INTEGER; a_pipeline: POINTER; a_opts: POINTER; a_read_prefs: POINTER): POINTER
			-- Execute an aggregation pipeline
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_collection_aggregate ((mongoc_collection_t *)$a_collection,
												  (mongoc_query_flags_t)$a_flags,
												  (const bson_t *)$a_pipeline,
												  (const bson_t *)$a_opts,
												  (const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_collection_find_and_modify (coll: POINTER; query: POINTER; sort: POINTER;
			update: POINTER; fields: POINTER; remove: BOOLEAN; upsert: BOOLEAN;
			new_doc: BOOLEAN; reply: POINTER; error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_collection_find_and_modify(
					(mongoc_collection_t*)$coll,
					(const bson_t*)$query,
					(const bson_t*)$sort,
					(const bson_t*)$update,
					(const bson_t*)$fields,
					$remove,
					$upsert,
					$new_doc,
					(bson_t*)$reply,
					(bson_error_t*)$error
				);
			]"
		end


feature -- Collection Operations

    c_mongoc_collection_count_documents (collection: POINTER; filter: POINTER; opts: POINTER; read_prefs: POINTER; reply: POINTER; error: POINTER): INTEGER_64
            -- Count documents in collection matching filter
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to count from
            --   filter: const bson_t* - the filter to match documents
            --   opts: const bson_t* - optional query options
            --   read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_count_documents(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$filter,
                    (const bson_t *)$opts,
                    (const mongoc_read_prefs_t *)$read_prefs,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_estimated_document_count (collection: POINTER; opts: POINTER; read_prefs: POINTER; reply: POINTER; error: POINTER): INTEGER_64
            -- Get an estimated count of documents in collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to count from
            --   opts: const bson_t* - optional query options
            --   read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_estimated_document_count(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$opts,
                    (const mongoc_read_prefs_t *)$read_prefs,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_update_many (collection: POINTER; selector: POINTER; update: POINTER; opts: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Update all documents matching selector
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to update
            --   selector: const bson_t* - the query to match documents
            --   update: const bson_t* - the update to apply
            --   opts: const bson_t* - optional update options
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_update_many(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$selector,
                    (const bson_t *)$update,
                    (const bson_t *)$opts,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_command_simple (collection: POINTER; command: POINTER; read_prefs: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Execute a command on the collection.
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to execute the command on
            --   command: const bson_t* - the command to execute
            --   read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   reply: bson_t* - storage for the command's result document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_command_simple(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$command,
                    (const mongoc_read_prefs_t *)$read_prefs,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_delete_many (collection: POINTER; selector: POINTER; opts: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Delete all documents matching selector
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to delete from
            --   selector: const bson_t* - the query to match documents
            --   opts: const bson_t* - optional delete options
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_delete_many(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$selector,
                    (const bson_t *)$opts,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_create_indexes_with_opts (collection: POINTER; models: POINTER; n_models: INTEGER; opts: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Create multiple indexes on the collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to create indexes on
            --   models: mongoc_index_model_t** - array of index model pointers
            --   n_models: size_t - number of index models
            --   opts: const bson_t* - optional additional options
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_create_indexes_with_opts(
                    (mongoc_collection_t *)$collection,
                    (mongoc_index_model_t **)$models,
                    (size_t)$n_models,
                    (const bson_t *)$opts,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_drop_index (collection: POINTER; index_name: POINTER; error: POINTER): BOOLEAN
            -- Drop an index from the collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to drop the index from
            --   index_name: const char* - name of the index to drop
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_drop_index(
                    (mongoc_collection_t *)$collection,
                    (const char *)$index_name,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_find_indexes_with_opts (collection: POINTER; opts: POINTER): POINTER
            -- Fetch a cursor containing documents for each index in the collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to get indexes from
            --   opts: const bson_t* - optional additional options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_find_indexes_with_opts(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$opts
                );
            ]"
        end

feature -- Mongo Database

	c_mongoc_database_create_collection (a_database: POINTER; a_name: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_database_create_collection ((mongoc_database_t *)$a_database,
				                                   (const char *)$a_name,
				                                   (const bson_t *)$a_opts,
				                                   (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_get_collection_names_with_opts (a_database: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
					   char **strv;
					   strv = mongoc_database_get_collection_names_with_opts  ($a_database, $a_opts, $a_error);
				 	   return strv;
			]"
		end

	c_mongoc_database_get_collection_names_count (a_database: POINTER; a_opts: POINTER; a_error: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				char **strv;
				strv = mongoc_database_get_collection_names_with_opts ($a_database, $a_opts, $a_error);
				int i;
				for (i = 0; strv[i]; i++);
				return i;
			]"
		end

	c_mongoc_database_has_collection (a_database: POINTER; a_name: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN) mongoc_database_has_collection ((mongoc_database_t *)$a_database,
				                                (const char *)$a_name,
				                                (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_drop_with_opts (a_database: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN) mongoc_database_drop_with_opts ((mongoc_database_t *)$a_database,
				                                (const bson_t *)$a_opts,
				                                (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_get_collection (a_database: POINTER; a_name: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_database_get_collection ((mongoc_database_t *)$a_database, (const char *)$a_name);
			]"
		end

	c_mongoc_database_get_name (a_database: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_database_get_name ((mongoc_database_t *)$a_database);	;
			]"
		end

feature -- Mongo Client Pool

	c_mongoc_client_pool_new (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_pool_new ((const mongoc_uri_t *)$a_uri);
			]"
		end

	c_mongoc_client_pool_pop (a_pool: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_pool_pop ((mongoc_client_pool_t *)$a_pool);
			]"
		end

	c_mongoc_client_pool_push (a_pool: POINTER; a_client: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				mongoc_client_pool_push ((mongoc_client_pool_t *)$a_pool, (mongoc_client_t *)$a_client);
			]"
		end

	c_mongoc_client_pool_try_pop (a_pool: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_pool_try_pop ((mongoc_client_pool_t *)$a_pool);
			]"
		end

	c_mongoc_client_pool_set_appname (a_pool: POINTER; a_name: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_client_pool_set_appname ((mongoc_client_pool_t *)$a_pool, (const char *)$a_name);
			]"
		end

	c_mongoc_client_pool_set_error_api (a_pool: POINTER; a_version: INTEGER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_client_pool_set_error_api ((mongoc_client_pool_t *)$a_pool, (int32_t)$a_version);
			]"
		end

feature -- Cursor

	c_mongo_cursor_next (a_cursor: POINTER; a_bson: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_cursor_next ((mongoc_cursor_t *)$a_cursor, (const bson_t **)$a_bson);
			]"
		end

feature -- URI

	c_mongoc_uri_new (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_new ((const char *)$a_uri);
			]"
		end

	c_mongoc_uri_copy (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_copy ((const mongoc_uri_t *)$a_uri);
			]"
		end

	c_mongoc_uri_get_string (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_get_string ((const mongoc_uri_t *)$a_uri);
			]"
		end

	c_mongoc_uri_new_with_error	(a_uri: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_new_with_error ((const char *)$a_uri,(bson_error_t *)$a_error);
			]"
		end

feature -- Mongo Read Preference

	c_mongoc_read_prefs_new (a_read_mode: INTEGER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_new ((mongoc_read_mode_t)$a_read_mode);
			]"
		end

	c_mongoc_read_prefs_is_valid (a_read_prefs: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_prefs_is_valid ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_get_mode (a_read_prefs: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_get_mode ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_get_tags (a_read_prefs: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_get_tags ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_set_mode (a_read_prefs: POINTER; a_mode: INTEGER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_mode ((mongoc_read_prefs_t *)$a_read_prefs,
                            (mongoc_read_mode_t)$a_mode);
			]"
		end

	c_mongoc_read_prefs_set_tags (a_read_prefs: POINTER; a_tags: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_tags ((mongoc_read_prefs_t *)$a_read_prefs,
                            (const bson_t *)$a_tags);
			]"
		end

	c_mongoc_read_prefs_set_max_staleness_seconds (a_read_prefs: POINTER; a_seconds: INTEGER_64)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_max_staleness_seconds ((mongoc_read_prefs_t *)$a_read_prefs,
                                             (int64_t)$a_seconds);
			]"
		end

feature -- Mongo Read Concern

	c_mongoc_read_concern_new: POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_concern_new();
			]"
		end

	c_mongoc_read_concern_get_level (a_read_concern: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (const char *) mongoc_read_concern_get_level ((const mongoc_read_concern_t *)$a_read_concern);
			]"
		end

	c_mongoc_read_concern_is_default (a_read_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_concern_is_default ((mongoc_read_concern_t *)$a_read_concern);
			]"
		end

	c_mongoc_read_concern_set_level (a_read_concern: POINTER; a_level: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_concern_set_level ((mongoc_read_concern_t *)$a_read_concern,
	                              (const char *)$a_level);
			]"
		end


feature -- Mongo Server Description

	c_mongoc_server_description_id (a_description: POINTER): INTEGER_32
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_INTEGER_32) mongoc_server_description_id ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_ismaster (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_ismaster ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_new_copy (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_new_copy ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_round_trip_time (a_description: POINTER): INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_INTEGER_64) mongoc_server_description_round_trip_time ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_type (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_type ((const mongoc_server_description_t *)$a_description);

			]"
		end

	c_mongoc_server_description_host (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_host ((const mongoc_server_description_t *)$a_description);

			]"
		end

feature -- MongoDB Session Options

	c_mongoc_session_opts_new: POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_session_opts_new();
			]"
		end


	c_mongoc_session_opts_get_causal_consistency (a_opts: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_session_opts_get_causal_consistency($a_opts);
			]"
		end

	c_mongoc_session_opts_set_causal_consistency (a_opts: POINTER; a_causal_consistency: BOOLEAN)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return 	mongoc_session_opts_set_causal_consistency ((mongoc_session_opt_t *)$a_opts, (bool)$a_causal_consistency);
			]"
		end

	c_mongoc_session_opts_clone (a_opts: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return 	mongoc_session_opts_clone ((const mongoc_session_opt_t *)$a_opts);
			]"
		end

feature -- Write Concern

	c_mongoc_write_concern_new: POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_new();"
		end

	c_mongoc_write_concern_is_default (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_is_default((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_is_acknowledged (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_is_acknowledged((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_is_valid (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_is_valid((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_w (a_concern: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_w((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_wtimeout_int64 (a_concern: POINTER): INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_wtimeout_int64((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_wtag (a_concern: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER)mongoc_write_concern_get_wtag((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_journal (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_journal((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_wmajority (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_wmajority((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_set_w (a_concern: POINTER; a_w: INTEGER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_w((mongoc_write_concern_t *)$a_concern, $a_w);"
		end

	c_mongoc_write_concern_set_wtimeout_int64 (a_concern: POINTER; a_wtimeout: INTEGER_64)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_wtimeout_int64((mongoc_write_concern_t *)$a_concern, $a_wtimeout);"
		end

	c_mongoc_write_concern_set_wmajority (a_concern: POINTER; a_wtimeout_msec: INTEGER_64)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_wmajority((mongoc_write_concern_t *)$a_concern, $a_wtimeout_msec);"
		end

	c_mongoc_write_concern_set_wtag (a_concern: POINTER; a_tag: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_wtag((mongoc_write_concern_t *)$a_concern, (const char *)$a_tag);"
		end

	c_mongoc_write_concern_set_journal (a_concern: POINTER; a_journal: BOOLEAN)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_journal((mongoc_write_concern_t *)$a_concern, $a_journal);"
		end

feature -- MongoDB Indexes

    c_mongoc_index_model_new (keys: POINTER; opts: POINTER): POINTER
            -- Create a new index model
            -- Parameters:
            --   keys: const bson_t* - document containing fields and order for the index
            --   opts: const bson_t* - optional index options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_index_model_new(
                    (const bson_t *)$keys,
                    (const bson_t *)$opts
                );
            ]"
        end

    c_mongoc_index_model_destroy (model: POINTER)
            -- Destroy an index model
            -- Parameters:
            --   model: mongoc_index_model_t* - the index model to destroy
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_index_model_destroy((mongoc_index_model_t *)$model);"
        end

feature -- Bulk Operations

    c_mongoc_bulk_operation_destroy (bulk: POINTER)
            -- Destroy a bulk operation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_destroy((mongoc_bulk_operation_t *)$bulk);
            ]"
        end

    c_mongoc_bulk_operation_execute (bulk: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Execute a bulk operation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_execute(
                    (mongoc_bulk_operation_t *)$bulk,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_insert (bulk: POINTER; document: POINTER): BOOLEAN
            -- Queue an insert operation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_insert(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$document
                );
            ]"
        end

    c_mongoc_bulk_operation_remove (bulk: POINTER; selector: POINTER)
            -- Queue a remove operation in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_remove(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector
                );
            ]"
        end

    c_mongoc_bulk_operation_get_server_id (bulk: POINTER): NATURAL_32
            -- Get the server id for a bulk operation
            -- Parameters:
            --   bulk: const mongoc_bulk_operation_t* - the bulk operation handle
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_get_server_id((const mongoc_bulk_operation_t *)$bulk);
            ]"
        end

    c_mongoc_bulk_operation_insert_with_opts (bulk: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue an insert operation with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   document: const bson_t* - document to insert
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_insert_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_remove_many_with_opts (bulk: POINTER; selector: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue a remove operation with options in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_remove_many_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_remove_one (bulk: POINTER; selector: POINTER)
            -- Queue a remove operation for a single document in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_remove_one(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector
                );
            ]"
        end

    c_mongoc_bulk_operation_remove_one_with_opts (bulk: POINTER; selector: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue a remove operation for a single document with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_remove_one_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_replace_one (bulk: POINTER; selector: POINTER; document: POINTER; upsert: BOOLEAN)
            -- Queue a replace operation for a single document in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - the replacement document
            --   upsert: bool - whether to insert if document not found
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_replace_one(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (bool)$upsert
                );
            ]"
        end

    c_mongoc_bulk_operation_replace_one_with_opts (bulk: POINTER; selector: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue a replace operation for a single document with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - the replacement document
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_replace_one_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_set_bypass_document_validation (bulk: POINTER; bypass: BOOLEAN)
            -- Set whether to bypass document validation for this bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   bypass: bool - whether to bypass document validation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_bypass_document_validation(
                    (mongoc_bulk_operation_t *)$bulk,
                    (bool)$bypass
                );
            ]"
        end

    c_mongoc_bulk_operation_set_client_session (bulk: POINTER; client_session: POINTER)
            -- Set an explicit client session to use for the bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   client_session: mongoc_client_session_t* - the client session to use
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_client_session(
                    (mongoc_bulk_operation_t *)$bulk,
                    (mongoc_client_session_t *)$client_session
                );
            ]"
        end

    c_mongoc_bulk_operation_set_comment (bulk: POINTER; comment: POINTER)
            -- Set a comment to associate with this bulk write operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   comment: const bson_value_t* - the comment value to set
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_comment(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_value_t *)$comment
                );
            ]"
        end

    c_mongoc_bulk_operation_set_server_id (bulk: POINTER; server_id: NATURAL_32)
            -- Set the server id for this bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   server_id: uint32_t - the server id to use
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_server_id(
                    (mongoc_bulk_operation_t *)$bulk,
                    (uint32_t)$server_id
                );
            ]"
        end

    c_mongoc_bulk_operation_set_let (bulk: POINTER; let: POINTER)
            -- Define constants that can be accessed by all operations in this bulk
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   let: const bson_t* - BSON document containing constant definitions
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_let(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$let
                );
            ]"
        end

    c_mongoc_bulk_operation_update (bulk: POINTER; selector: POINTER; document: POINTER; upsert: BOOLEAN)
            -- Queue an update operation in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
            --   document: const bson_t* - document containing the update operations
            --   upsert: bool - whether to insert if document not found
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_update(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (bool)$upsert
                );
            ]"
        end

    c_mongoc_bulk_operation_update_many_with_opts (bulk: POINTER; selector: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue an update operation to update multiple documents with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
            --   document: const bson_t* - document containing the update operations
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_update_many_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_update_one (bulk: POINTER; selector: POINTER; document: POINTER; upsert: BOOLEAN)
            -- Queue an update operation for a single document in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - document containing the update operations
            --   upsert: bool - whether to insert if document not found
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_update_one(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (bool)$upsert
                );
            ]"
        end

    c_mongoc_bulk_operation_update_one_with_opts (bulk: POINTER; selector: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue an update operation for a single document with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - document containing the update operations
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_update_one_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_get_write_concern (bulk: POINTER): POINTER
            -- Get the write concern for a bulk operation
            -- Parameters:
            --   bulk: const mongoc_bulk_operation_t* - the bulk operation handle
            -- Returns: const mongoc_write_concern_t* - the write concern
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_get_write_concern(
                    (const mongoc_bulk_operation_t *)$bulk
                );
            ]"
        end

end
