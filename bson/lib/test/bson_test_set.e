note
	description: "[
			Eiffel tests that can be executed by testing tool.
		]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	BSON_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_bson_new
			-- Test BSON object creation and initialization
		local
			l_bson: BSON
			l_bson2: BSON
			l_json: STRING
		do
				-- Test basic BSON creation
			create l_bson.make
			assert ("Expected initial length of 5", l_bson.len = 5)

				-- Test creation from JSON
			create l_bson.make_from_json ("{}")
			assert ("Expected empty JSON document length", l_bson.len = 5)

				-- Test JSON conversion
			l_json := l_bson.bson_as_json
			assert ("Expected JSON representation", l_json.same_string ("{ }"))

				-- Test document copying
			l_bson2 := l_bson.bson_copy
			assert ("Copy should have same length", l_bson2.len = l_bson.len)
			assert ("Documents should be equal", l_bson.bson_equal (l_bson2))

				-- Test key counting
			assert ("Empty document should have 0 keys", l_bson.bson_count_keys = 0)
		end

	test_bson_append_utf8
			-- Test appending UTF8 strings to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append a UTF8 string
			l_bson.bson_append_utf8 ("hello", "world")

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8} "{ %"hello%" : %"world%" }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

end

