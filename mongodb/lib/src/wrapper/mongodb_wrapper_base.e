note
	description: "Summary description for {MONGODB_WRAPPER_BASE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MONGODB_WRAPPER_BASE

inherit

	DISPOSABLE

	MEMORY_STRUCTURE


feature -- Error

	error: detachable BSON_ERROR
			-- last error.

	error_message: detachable STRING_32

	last_error: BOOLEAN
			-- last_error
			-- Indicates that there was an error during the last operation
		do
			Result := attached error or attached error_message
		end

	error_string: STRING_32
			-- Output a related error message, for the last operation.
		require
			was_error: last_error
		do
			if attached {BSON_ERROR} error as l_error then
				Result := "[Code:" + l_error.code.out + "]" + " [Domain:"+ l_error.domain.out + "]" + " [Message:" + l_error.message.out + "]"
			elseif attached error_message as l_error_message then
				Result := l_error_message
			else
				Result := "Unknown Error"
			end
		end

	set_error_message (a_message: READABLE_STRING_32)
			-- Set `error_message' with `a_message'
		do
			error_message := a_message
		end

	clean_up
			-- Clean up the last error.
		do
			error := Void
			error_message := Void
		end

end
