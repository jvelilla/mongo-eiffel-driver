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

	test_bson_append_null
			-- Test appending null value to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append a null value
			l_bson.bson_append_null ("hello")

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8} "{ %"hello%" : null }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_bool
			-- Test appending boolean value to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append a boolean value (true)
			l_bson.bson_append_boolean ("bool", True)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8} "{ %"bool%" : true }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_double
			-- Test appending double value to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append a double value (123.4567)
			l_bson.bson_append_double ("double", 123.4567)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8} "{ %"double%" : 123.4567 }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_document
			-- Test appending a document to BSON documents
		local
			l_bson: BSON
			l_doc: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Create an empty document to append
			create l_doc.make

				-- Append the empty document
			l_bson.bson_append_document ("document", l_doc)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8} "{ %"document%" : { } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_oid
			-- Test appending OID value to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
			l_oid: BSON_OID
		do
				-- Create a new BSON document
			create l_bson.make

				-- Create and initialize OID from string
			create l_oid.make_with_string ("1234567890abcdef1234abcd")

				-- Append the OID
			l_bson.bson_append_oid ("oid", l_oid)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"oid%" : { %"$oid%" : %"1234567890abcdef1234abcd%" } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_array
			-- Test appending an array to BSON documents
		local
			l_bson: BSON
			l_array: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Create a BSON document to serve as the array
			create l_array.make
			l_array.bson_append_utf8 ("0", "hello")
			l_array.bson_append_utf8 ("1", "world")

				-- Append the array to the main document
			l_bson.bson_append_array ("array", l_array)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"array%" : [ %"hello%", %"world%" ] }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_binary
			-- Test appending binary data to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
			l_binary: ARRAY [NATURAL_8]
		do
				-- Create a new BSON document
			create l_bson.make

				-- Create binary data array (equivalent to {'1', '2', '3', '4'})
			create l_binary.make_filled (0, 1, 4)
			l_binary [1] := 49 -- ASCII '1'
			l_binary [2] := 50 -- ASCII '2'
			l_binary [3] := 51 -- ASCII '3'
			l_binary [4] := 52 -- ASCII '4'

				-- Append the binary data with BSON_SUBTYPE_USER
			l_bson.bson_append_binary ("binary", {BSON_SUBTYPE}.BSON_SUBTYPE_USER, l_binary)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"binary%" : { %"$binary%" : { %"base64%" : %"MTIzNA==%", %"subType%" : %"80%" } } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_time_t
			-- Test appending time_t value to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
			l_time: INTEGER_64
		do
				-- Create a new BSON document
			create l_bson.make

				-- Set time value (1234567890 Unix timestamp)
			l_time := 1234567890

				-- Append the time_t value
			l_bson.bson_append_time ("time_t", l_time)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"time_t%" : { %"$date%" : %"2009-02-13T23:31:30.000Z%" } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_timeval
			-- Test appending timeval value to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append timeval (1234567890 seconds, 0 microseconds)
			l_bson.bson_append_timeval ("time_t", 1234567890, 0)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"time_t%" : { %"$date%" : %"2009-02-13T23:31:30.000Z%" } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_regex
			-- Test appending regex value to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append regex with pattern "^abcd" and options "ilx"
				-- Note: options must contain valid regex option characters: 'i', 'm', 'x', 'l', 's', 'u'
			l_bson.bson_append_regex ("regex", "^abcd", "ilx")

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"regex%" : { %"$regex%" : %"^abcd%", %"$options%" : %"ilx%" } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_relaxed_extended_json.same_string (l_expected.bson_as_relaxed_extended_json))
		end

	test_bson_append_code
			-- Test appending JavaScript code to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append JavaScript code
			l_bson.bson_append_code ("code", "var a = {};")

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"code%" : { %"$code%" : %"var a = {};%" } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_json.same_string (l_expected.bson_as_json))
		end

	test_bson_append_code_with_scope
			-- Test appending JavaScript code with scope to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
			l_scope: BSON
		do
				-- Test 1: Code with NULL scope (converts to regular CODE type)
			create l_bson.make
			l_bson.bson_append_code_scope ("code", "var a = {};", Void)

				-- Create expected document for code without scope
			create l_expected.make_from_json ({STRING_8}
					"{ %"code%" : { %"$code%" : %"var a = {};%" } }")

				-- Verify documents are equal
			assert ("Documents should be equal (null scope)", l_bson.bson_equal (l_expected))

				-- Test 2: Code with empty scope
			create l_bson.make
			create l_scope.make
			l_bson.bson_append_code_scope ("code", "var a = {};", l_scope)

				-- Create expected document for code with empty scope
			create l_expected.make_from_json ({STRING_8}
					"{ %"code%" : { %"$code%" : %"var a = {};%", %"$scope%" : { } } }")

				-- Verify documents are equal
			assert ("Documents should be equal (empty scope)", l_bson.bson_equal (l_expected))

				-- Test 3: Code with non-empty scope
			create l_bson.make
			create l_scope.make
			l_scope.bson_append_utf8 ("foo", "bar")
			l_bson.bson_append_code_scope ("code", "var a = {};", l_scope)

				-- Create expected document for code with non-empty scope
			create l_expected.make_from_json ({STRING_8}
					"{ %"code%" : { %"$code%" : %"var a = {};%", %"$scope%" : { %"foo%" : %"bar%" } } }")

				-- Verify documents are equal
			assert ("Documents should be equal (non-empty scope)", l_bson.bson_equal (l_expected))
		end

	test_bson_append_int32
			-- Test appending 32-bit integers to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append multiple int32 values
			l_bson.bson_append_integer_32 ("a", -123)
			l_bson.bson_append_integer_32 ("c", 0)
			l_bson.bson_append_integer_32 ("b", 123)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"a%" : -123, %"c%" : 0, %"b%" : 123 }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_relaxed_extended_json.same_string (l_expected.bson_as_relaxed_extended_json))
		end

	test_bson_append_int64
			-- Test appending 64-bit integers to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
		do
				-- Create a new BSON document
			create l_bson.make

				-- Append int64 value
			l_bson.bson_append_integer_64 ("a", 100000000000000)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
					"{ %"a%" : 100000000000000 }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_relaxed_extended_json.same_string (l_expected.bson_as_relaxed_extended_json))
		end

	test_bson_append_decimal128
			-- Test appending Decimal128 values to BSON documents
		local
			l_bson: BSON
			l_expected: BSON
			l_decimal: BSON_DECIMAL_128
		do
				-- Create a new BSON document
			create l_bson.make

				-- Create and set up the Decimal128 value
			create l_decimal.make
			l_decimal.set_high (0)
			l_decimal.set_low (1)

				-- Append the Decimal128 value
			l_bson.bson_append_decimal128 ("a", l_decimal)

				-- Create the expected BSON document from JSON
			create l_expected.make_from_json ({STRING_8}
				"{ %"a%" : { %"$numberDecimal%" : %"1E-6176%" } }")

				-- Verify the documents are equal
			assert ("Documents should be equal", l_bson.bson_equal (l_expected))

				-- Additional verification through JSON representation
			assert ("JSON representation should match",
				l_bson.bson_as_relaxed_extended_json.same_string (l_expected.bson_as_relaxed_extended_json))
		end

end

