#!/usr/local/bin/python
import plistlib
import os
import dircache
import glob
print glob.glob("Mapping/*.plist")

mappinglist = glob.glob("Mapping/*.plist")

FOLDER_INTERNAL_PREFIX = "Classes/Internal/_"
FOLDER_EXTERNAL_PREFIX = "Classes/"

DEFAULT_PROPERTY_COMMENT = "\n/** \n *  No comment provided by engineer. \n */ \n"

PROPERTY_VAR = "	var"

PROPERTY_TYPE_STRING = "String"
PROPERTY_TYPE_DOUBLE = "Double"
PROPERTY_TYPE_FLOAT = "Float"
PROPERTY_TYPE_INT = "Int"
PROPERTY_TYPE_BOOL= "Bool"

IMPORT_FOUNDATION = "import Foundation\n"

# Generates the unternal and external .m files
# External 0 - Internal '_' prefixed class with all the properties
# External 1 - External class for enhancements.
def generate_file(classname, external):
	# Generate the file name
	if external == 0:
		filename = FOLDER_INTERNAL_PREFIX + classname + '.swift'
	if external == 1:
		filename = FOLDER_EXTERNAL_PREFIX + classname + '.swift'
	
	# Open File
	headerfile = open(filename, "wb")
	
	append_import_staments(classname, headerfile)
	append_compiler_directives(classname, headerfile, external)
	
	if external == 0:
		#return header becasue it needs the properties appended
		return headerfile;
	if external == 1:
		#close the file because it is external, and does not need any modification
		close_file (headerfile)


def append_import_staments(classname, headerfile):
		headerfile.write(IMPORT_FOUNDATION + '\n')
		

def append_compiler_directives (classname, headerfile, external):
	if external == 0:
		headerfile.write('\nclass _' + classname + ' {\n\n')
	if external == 1:
		headerfile.write('\nclass ' + classname + ' : _' + classname + ' {\n')


def append_instance_variable(classfile, propertyname, datatype, optional):
	#headerfile.write (DEFAULT_PROPERTY_COMMENT)
	if datatype == PROPERTY_TYPE_STRING:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_STRING)
	if datatype == PROPERTY_TYPE_INT:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_INT)
	if datatype == PROPERTY_TYPE_DOUBLE:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_DOUBLE)
	if datatype == PROPERTY_TYPE_FLOAT:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_FLOAT)
	if datatype == PROPERTY_TYPE_BOOL:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_BOOL)
	
	if optional == 1:
		classfile.write('?')
	
	classfile.write('\n')

def append_properties(classfile, mapping, optional):
	
	propertyList = []
	pl = plistlib.readPlist(mapping)
	for key in pl.keys():
		#print 'key - ' + key

		propertytype = ""
		isoptional = 1

		for subkey in pl[key]:
			if subkey == 'type':
				propertytype = pl[key][subkey]
			if subkey == 'optional':
				if pl[key][subkey] == 'false':
					isoptional = 0
		if optional == isoptional:
			propertyList.append(key)
			append_instance_variable(internal, key, propertytype, optional)
	return propertyList


# Append } to the end of a file and close it
def close_file(headerfile):
	headerfile.write('\n} ')
	headerfile.close();

for mapping in mappinglist:
	
	propertyList = []

	classname = mapping.split('/', 1 )[-1].split('.', 1 )[0]
	
	internal = generate_file(classname, 0)
	external = generate_file(classname, 0)
	
	#generate_header_file(classname, 1)
	generate_file(classname, 1)
	generate_file(classname, 0)

	propertyList = propertyList + append_properties(internal, mapping, 0)
	internal.write('\n')
	propertyList = propertyList + append_properties(internal, mapping, 1)

	print '\n' + classname + '\n'
	print propertyList
	
	propertyList = []
	
	close_file(internal)
	







