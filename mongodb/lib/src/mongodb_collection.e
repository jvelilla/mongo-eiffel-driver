note
	description: "[
		Object representing a mongoc_collection_t structure.
		It provides access to a MongoDB collection. This handle is useful for actions for most CRUD operations, I.e. insert, update, delete, find, etc.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_collection_t", "src=http://mongoc.org/libmongoc/current/mongoc_collection_t.html", "protocol=uri"

class
	MONGODB_COLLECTION

inherit

	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
		do
			memory_make
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_collection_destroy (item)
			end
		end


feature -- Access

	find_with_opts (a_filter: BSON; a_opts: detachable BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE): MONGODB_CURSOR
			-- 'a_filter': A bson_t containing the query to execute.
			-- 'a_opts:' An optional bson_t query options, including sort order and which fields to return
			-- 'a_read_prefs': An optional reading preferences.
			-- Return a mongo cursor.
		note
			EIS: "name=mongoc_collection_find_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_find_with_opts.html", "protocol=uri"
		local
			l_pointer: POINTER
			l_opts: POINTER
			l_read_prefs: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			l_pointer := {MONGODB_EXTERNALS}.c_mongoc_collection_find_with_opts (item, a_filter.item, l_opts, l_read_prefs)
			create Result.make (l_pointer)
		end

	count (a_flags: INTEGER; a_query: BSON; a_skip: INTEGER_64; a_limit: INTEGER_64; a_read_prefs: detachable MONGODB_READ_PREFERENCE; ): INTEGER_64
			-- This feature shall execute a count query `a_query' on the current collection.
			-- 'a_flags': A mongoc_query_flags_t.
			-- 'a_query': A bson_t containing the query.
			-- 'a_skip': A int64_t, zero to ignore.
			-- 'a_limit': A int64_t, zero to ignore.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t.
		note
			EIS: "name=mongoc_collection_count", "src=http://mongoc.org/libmongoc/current/mongoc_collection_count.html", "protocol=uri"
		require
			is_valid_falg: (create {MONGODB_QUERY_FLAG}).is_valid_flag (a_flags)
		local
			l_read_prefs: POINTER
			l_error: POINTER
		do
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			Result := {MONGODB_EXTERNALS}.c_mongoc_collection_count (item, a_flags, a_query.item, a_skip, a_limit, l_read_prefs, l_error)
			if Result >= 0 then
				-- do nothing
			else
				create error.make_by_pointer (l_error)
			end
		end

	find_and_modify (query: BSON; sort: detachable BSON; update: BSON; fields: detachable BSON;
					 remove: BOOLEAN; upsert: BOOLEAN; new_doc: BOOLEAN; reply: BSON)
			-- Update and return an object.
			-- `query`: A bson_t containing the query to locate target document(s)
			-- `sort`: A bson_t containing the sort order for `query`
			-- `update`: A bson_t containing an update spec
			-- `fields`: An optional bson_t containing the fields to return or Void
			-- `remove`: If the matching documents should be removed
			-- `upsert`: If an upsert should be performed
			-- `new_doc`: If the new version of the document should be returned
			-- `reply`: A bson_t to contain the results
		note
			EIS: "name=mongoc_collection_find_and_modify", "src=http://mongoc.org/libmongoc/current/mongoc_collection_find_and_modify.html", "protocol=uri"
		local
			l_sort: POINTER
			l_fields: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			if attached sort then
				l_sort := sort.item
			end
			if attached fields then
				l_fields := fields.item
			end

			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_find_and_modify (
				item,            -- collection
				query.item,      -- query
				l_sort,          -- sort
				update.item,     -- update
				l_fields,        -- fields
				remove,          -- remove
				upsert,          -- upsert
				new_doc,         -- new
				reply.item,      -- reply
				l_error.item     -- error
			)

			if not l_res then
				create error.make_by_pointer (l_error.item)
			end
		end

feature -- Command

	insert_one (a_document: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
			-- This feature shall insert document `a_document' into collection.
			-- a_document: A BSON document
			-- a_opts: An optional BSON containing additional options.
			-- a_reply: Optional. An uninitialized bson_t populated with the insert result.
		note
			EIS: "name=mongoc_collection_insert_one", "src=http://mongoc.org/libmongoc/current/mongoc_collection_insert_one.html", "protocol=uri"
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_insert_one (item, a_document.item, l_opts, l_reply, l_error.item)
			if l_res then
				-- do nothing
			else
				create error.make_by_pointer (l_error.item)
			end
		end

	insert_many (a_documents: LIST [BSON]; a_opts: detachable BSON; a_reply: detachable BSON)
			--documents: An array of pointers to bson_t.
			--opts may be NULL or a BSON document with additional command options:
			--reply: Optional. An uninitialized bson_t populated with the insert result, or NULL.
		note
			EIS: "name=mongoc_collection_insert_one", "src=http://mongoc.org/libmongoc/current/mongoc_collection_insert_many.html", "protocol=uri"
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_pos: INTEGER
			l_item: MANAGED_POINTER
			l_res: BOOLEAN
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end

			create l_item.make (a_documents.count*8)
			from
				a_documents.start
				l_pos := 0
			until
				a_documents.after
			loop
				l_item.put_pointer (a_documents.item.item, l_pos)
				a_documents.forth
				l_pos := l_pos + 8
			end

			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_insert_many (item, l_item.item, a_documents.count , l_opts, l_reply, l_error.item)
			if l_res then
				-- do nothing
			else
				create error.make_by_pointer (l_error.item)
			end
		end

	update_one (a_selector: BSON; a_update: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
			-- a_selector: A bson_t containing the query to match the document for updating.
			-- a_update: A bson_t containing the update to perform.
			-- a_opts: An optional bson_t containing additional options
			-- a_reply: Optional. An uninitialized bson_t populated with the update result.
			-- This feature updates at most one document in collection that matches selector `a_selector'.
		note
			EIS: "name=mongoc_collection_update_one","src=http://mongoc.org/libmongoc/current/mongoc_collection_update_one.html", "protocol=uri"
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_update_one (item, a_selector.item, a_update.item, l_opts, l_reply, l_error.item)
			if l_res then
				-- do nothing
			else
				create error.make_by_pointer (l_error.item)
			end
		end

	delete_one (a_selector: BSON; a_opts: detachable BSON; a_reply: detachable BSON )
			-- a_selector: A bson_t containing the query to match documents.
			-- a_opts: An optional bson_t containing additional options.
			-- a_reply: Optional. An uninitialized bson_t populated with the delete result, or NULL.
			-- This feature removes at most one document in the given collection that matches selector `a_selector'.		
		note
			EIS: "name=mongoc_collection_delete_one","src=http://mongoc.org/libmongoc/current/mongoc_collection_delete_one.html","protocol=uri"
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_delete_one (item, a_selector.item, l_opts, l_reply, l_error.item)
			if l_res then
				-- do nothing
			else
				create error.make_by_pointer (l_error.item)
			end
		end

feature -- Aggregation

	aggregate (a_pipeline: BSON; a_opts: detachable BSON; a_read_pref: detachable MONGODB_READ_PREFERENCE ): MONGODB_CURSOR
			-- Execute an aggregation framework pipeline using `a_pipeline`.
			-- Returns a cursor to the result set.
		local
			l_opts: POINTER
			l_flags: INTEGER
			l_read_prefs: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_read_pref then
				l_read_prefs := a_read_pref.item
			end
			l_flags := (create {MONGODB_QUERY_FLAG}).mongoc_query_none
			create Result.make (
				{MONGODB_EXTERNALS}.c_mongoc_collection_aggregate (
					item,
					l_flags,
					a_pipeline.item,
					l_opts,
					l_read_prefs
				)
			)
		end

feature -- Status Report

	has_error: BOOLEAN
			-- Indicates that there was an error during the last operation
		do
			Result := attached error
		end

	error_string: STRING
			-- Output a related error message.
		require
			was_error: has_error
		do
			if attached {BSON_ERROR} error as l_error then
				Result := "[Code:" + l_error.code.out + "]" + " [Domain:"+ l_error.domain.out + "]" + " [Message:" + l_error.message.out + "]"
			else
				Result := "Unknown Error"
			end
		end

	error: detachable BSON_ERROR
			-- last error.	

feature -- Drop

	drop_with_opts	(a_opts: detachable BSON)
			-- Drop the current collection, including all indexes associated with the collection.
			-- If no write concern is provided in a_opts, the collection's write concern is used.
		note
			EIS: "name=mongoc_collection_drop_with_opts","src=http://mongoc.org/libmongoc/current/mongoc_collection_drop_with_opts.html","protocol=uri"
		local
			l_opts: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			if attached a_opts then
				l_opts := l_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_drop_with_opts (item, l_opts, l_error.item)
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
			"return sizeof(mongoc_collection_t *);"
		end

	c_mongoc_collection_destroy (a_collection: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_collection_destroy ((mongoc_collection_t *)$a_collection);"
		end

end
