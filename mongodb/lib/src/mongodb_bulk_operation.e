note
    description: "[
        Object representing a mongoc_bulk_operation_t structure.
        It provides an abstraction for submitting multiple write operations as a single batch.
    ]"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=mongoc_bulk_operation_t", "src=http://mongoc.org/libmongoc/current/mongoc_bulk_operation_t.html", "protocol=uri"

class
    MONGODB_BULK_OPERATION

inherit

    MONGODB_WRAPPER_BASE
        rename
            make as memory_make
        end

create
    make, make_by_pointer

feature {NONE} -- Initialization

    make
            -- Create a new bulk operation instance
        do
            memory_make
        end

feature -- Execute

    execute (a_reply: BSON): BOOLEAN
            -- Execute the bulk operation
            -- Returns True on success, False on error
            -- `a_reply`: Optional. An uninitialized bson_t populated with the operation result
        local
            l_error: BSON_ERROR
        do
            create l_error.make
            Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_execute (item, a_reply.item, l_error.item)
            if not Result then
                create error.make_by_pointer (l_error.item)
            end
        end


feature -- Access

    server_id: NATURAL_32
            -- Get the server id associated with this bulk operation.
            -- Returns 0 if no server id has been assigned.
        note
            EIS: "name=mongoc_bulk_operation_get_server_id", "src=http://mongoc.org/libmongoc/current/mongoc_bulk_operation_get_server_id.html", "protocol=uri"
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_get_server_id (item)
        end

feature -- Error

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

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_bulk_operation_destroy (item)
			end
		end

feature -- Operations

	insert (a_document: BSON): BOOLEAN
            -- Queue an insert operation
            -- `a_document`: A bson_t containing the document to insert
            -- Returns True on success, False on error
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_insert (item, a_document.item)
        end

    insert_with_opts (a_document: BSON; a_opts: detachable BSON): BOOLEAN
            -- Queue an insert operation with options
            -- `a_document`: The document to insert
            -- `a_opts`: Optional additional options (may be Void)
            -- Returns True on success, False on error
            -- Note: The insert is not performed until execute() is called
        require
            valid_document: a_document /= Void
        local
            l_error: BSON_ERROR
            l_opts: POINTER
        do
            if attached a_opts then
                l_opts := a_opts.item
            end
            create l_error.make
            Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_insert_with_opts (
                item,            -- bulk operation
                a_document.item, -- document to insert
                l_opts,          -- options
                l_error.item     -- error info
            )
            if not Result then
                create error.make_by_pointer (l_error.item)
            end
        ensure
            error_set: not Result implies error /= Void
        end

	remove (a_selector: BSON)
            -- Queue a remove operation to remove all documents matching the selector.
            -- Note: This only queues the operation. To execute it, call `execute`.
            -- `a_selector`: A BSON document containing the query to match documents for removal
        require
            valid_selector: a_selector /= Void
        do
            {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove (
                item,              -- bulk operation
                a_selector.item    -- selector
            )
        end

    remove_many_with_opts (a_selector: BSON; a_opts: detachable BSON): BOOLEAN
            -- Queue a remove operation to remove all documents matching the selector with additional options.
            -- `a_selector`: A BSON document containing the query to match documents for removal
            -- `a_opts`: Optional BSON document containing additional options:
            --          - collation: Configure textual comparisons
            --          - hint: Specify index to use for the query
            -- Returns: True on success, False on error
            -- Note: This only queues the operation. To execute it, call `execute`.
        require
            valid_selector: a_selector /= Void
        local
            l_error: BSON_ERROR
            l_opts: POINTER
        do
            if attached a_opts then
                l_opts := a_opts.item
            end
            create l_error.make
            Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove_many_with_opts (
                item,              -- bulk operation
                a_selector.item,   -- selector
                l_opts,           -- options (may be null)
                l_error.item      -- error info
            )
            if not Result then
                create error.make_by_pointer (l_error.item)
            end
        ensure
            error_set: not Result implies error /= Void
        end

    remove_one (a_selector: BSON)
            -- Queue a remove operation to remove a single document matching the selector.
            -- Note: This only queues the operation. To execute it, call `execute`.
            -- `a_selector`: A BSON document containing the query to match document for removal
        require
            valid_selector: a_selector /= Void
        do
            {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove_one (
                item,              -- bulk operation
                a_selector.item    -- selector
            )
        end

    remove_one_with_opts (a_selector: BSON; a_opts: detachable BSON): BOOLEAN
            -- Queue a remove operation to remove a single document matching the selector with additional options.
            -- `a_selector`: A BSON document containing the query to match document for removal
            -- `a_opts`: Optional BSON document containing additional options:
            --          - collation: Configure textual comparisons
            --          - hint: Specify index to use for the query
            -- Returns: True on success, False on error
            -- Note: This only queues the operation. To execute it, call `execute`.
        require
            valid_selector: a_selector /= Void
        local
            l_error: BSON_ERROR
            l_opts: POINTER
        do
            if attached a_opts then
                l_opts := a_opts.item
            end
            create l_error.make
            Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove_one_with_opts (
                item,              -- bulk operation
                a_selector.item,   -- selector
                l_opts,            -- options 
                l_error.item       -- error info
            )
            if not Result then
                create error.make_by_pointer (l_error.item)
            end
        ensure
            error_set: not Result implies error /= Void
        end

    replace_one (a_selector: BSON; a_document: BSON; a_upsert: BOOLEAN)
            -- Queue a replace operation to replace a single document matching the selector.
            -- Note: This only queues the operation. To execute it, call `execute`.
            -- `a_selector`: A BSON document containing the query to match document for replacement
            -- `a_document`: A BSON document containing the replacement document
            -- `a_upsert`: True if this should be an upsert (insert if not found)
        do
            {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_replace_one (
                item,              -- bulk operation
                a_selector.item,   -- selector
                a_document.item,   -- replacement document
                a_upsert           -- upsert flag
            )
        end

    replace_one_with_opts (a_selector: BSON; a_document: BSON; a_opts: detachable BSON): BOOLEAN
            -- Queue a replace operation to replace a single document matching the selector with additional options.
            -- `a_selector`: A BSON document containing the query to match document for replacement
            -- `a_document`: A BSON document containing the replacement document
            -- `a_opts`: Optional BSON document containing additional options:
            --          - collation: Configure textual comparisons
            --          - hint: Specify index to use for the query
            --          - upsert: Whether to insert if document not found
            -- Returns: True on success, False on error
            -- Note: This only queues the operation. To execute it, call `execute`.
        local
            l_error: BSON_ERROR
            l_opts: POINTER
        do
            if attached a_opts then
                l_opts := a_opts.item
            end
            create l_error.make
            Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_replace_one_with_opts (
                item,              -- bulk operation
                a_selector.item,   -- selector
                a_document.item,   -- replacement document
                l_opts,            -- options
                l_error.item       -- error info
            )
            if not Result then
                create error.make_by_pointer (l_error.item)
            end
        ensure
            error_set: not Result implies error /= Void
        end

feature -- Settings

    set_bypass_document_validation (bypass: BOOLEAN)
            -- Set whether to bypass document validation for this bulk operation.
            -- `bypass`: True to bypass document validation, False to enforce it
        do
            {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_set_bypass_document_validation (
                item,    -- bulk operation
                bypass   -- bypass flag
            )
        end

    set_client_session (a_session: MONGODB_CLIENT_SESSION)
            -- Sets an explicit client session to use for the bulk operation.
            -- Note: It is an error to use a session for unacknowledged writes.
            -- `a_session`: The client session to use for this bulk operation
        require
            session_not_void: a_session /= Void
        do
            {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_set_client_session (
                item,           -- bulk operation
                a_session.item  -- client session
            )
        end

feature {NONE} -- Implementation

    structure_size: INTEGER
            -- Size to allocate (in bytes)
        do
            Result := struct_size
        end

    struct_size: INTEGER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return sizeof(mongoc_bulk_operation_t *);"
        end

    c_mongoc_bulk_operation_destroy (a_bulk: POINTER)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_bulk_operation_destroy((mongoc_bulk_operation_t *)$a_bulk);"
        end

end
