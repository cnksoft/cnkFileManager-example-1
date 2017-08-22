-- ***********************************************************
-- This example shows the ussage for the plugin cnkFileManager
-- (C)2017 CNK Soft.
-- ***********************************************************
-- Button 1 - using the pickFile() get an image and show it for 3 seconds
-- Button 2 - using the pickFile() get a file and copy it to Documents Directory.
-- Button 3 - using the pickFile() get the Uri, Name and size for a file.
-- Button 4 - using the getFileFromUri() copy a file to the Documents Directory.
--
-- Please, use the console to read the output. I have tried to explain each step.
-- After each action, the directory for Temporary and Documents will be shown using Lfs.
--
-- support: http://www.cnksoft.es/index.php/otro-software/9-plugin-cnkfilemanager-for-corona
--
-- Remember to include the following at the built.settings directory:
--
--     	plugins = {
--        	['plugin.cnkFileManager'] = {publisherId = 'es.cnksoft'},
--     	},
--
--
-- Also, remember to include the Android Permission as follow:
--
-- 		android =
-- 		{
--     		"android.permission.READ_EXTERNAL_STORAGE"
-- 		},
--
--



--plugin for manage uri
local library = require "plugin.cnkFileManager"


--additional plugins
local lfs = require( "lfs" )
local widget = require( "widget")



--GENERAL VARIABLES
local myUri = "" --variable that will hold an Uri to use with buttons 3 and 4




--GENERICS FUNCTIONS COMMON TO ALL CODE
--list Documents Directory
local function listDocDirectory()

	local _path = system.pathForFile( "", system.DocumentsDirectory )

	--print ("*** Files in Documents Directory ***")

	print ("\n--- Files in Documents Directory ---")
	for file in lfs.dir( _path ) do
	    -- "file" is the current file or directory name
	    --print( "Found file: " .. file )
	    print ( file )
	end
	print ("----------------------------------------------\n")

end


--list temporary directory
local function listTempDirectory()
	

	local _path = system.pathForFile( "", system.TemporaryDirectory )

	--print ("*** Files in Temporary Directory ***")

	print ("\n--- Files in Temporary Directory ---")
	for file in lfs.dir( _path ) do
	    -- "file" is the current file or directory name
	    --print( "Found file: " .. file )
	    print ( file )
	end
	print ("---------------------------------------------\n")

end


--fit an image without lost its proportions.
local function fitImage( displayObject, fitWidth, fitHeight, enlarge )
	-- From https://coronalabs.com/blog/2014/06/10/tutorial-fitting-images-to-a-size/
	-- Ussage: fitImage( icon2, 200, 200, true )
	-- first determine which edge is out of bounds
	--
	local scaleFactor = fitHeight / displayObject.height 
	local newWidth = displayObject.width * scaleFactor
	if newWidth > fitWidth then
		scaleFactor = fitWidth / displayObject.width 
	end
	if not enlarge and scaleFactor > 1 then
		return
	end
	displayObject:scale( scaleFactor, scaleFactor )
end


--receive the event and show the image
local function listener1( event )

	if event.done then

		if event.done == "ok" then
			print ("\nFILE COPIED TO " .. event.destPath .. " with name: " .. event.destFileName)
			print ("\nThe file is : " .. event.size .. " Bytes Size.")


			local imagePath = system.pathForFile( event.destFileName, system.TemporaryDirectory )
			print ("\nOpening Image " .. imagePath)

			local myImage = display.newImage( imagePath )
			myImage.x = display.contentCenterX
			myImage.y = display.contentCenterY
			fitImage ( myImage, 250, 250, false)



			timer.performWithDelay( 3000, function()
				--destroy image
				if myImage then
					myImage:removeSelf()
					myImage = nil
				end
			end)


		elseif event.done == "dummy" then
			print ("\nFILE FROM URI: " .. event.uri .. " Can be copied to Path :" .. event.destPath .. " with name: " .. event.destFileName .. " in a safe way")
			print ("\nThe file is : " .. event.size .. " Bytes Size. and has the original Name: " .. event.origFileName)

		end

		--list the directories
		listTempDirectory()
		listDocDirectory()


	elseif event.error then
		print ("\nERROR " .. event.error .. " With errorCode: " .. event.errorCode)
		print ("\nTrying to copy the file from the uri: " .. event.uri .. " To the path : " .. event.destPath)


		if event.errorCode == "2" then
			print ("\nThe User Refused to give permission to the app to get the file. Try again and give permission. It is safe!")

		elseif event.errorCode == "1" then
			print ("\nYou NEED to include the following at the build.settings file:")
			print ("\nandroid.permission.READ_EXTERNAL_STORAGE")
		end

	end

end



--receive the event and show the details about the file
local function listener2( event )

	if event.done then

		if event.done == "ok" then
		print ("\nFILE COPIED TO " .. event.destPath .. " with name: " .. event.destFileName)
		print ("\nThe file is : " .. event.size .. " Bytes Size.")


		local myText = display.newText( "File " .. event.destFileName .. " Copied !", display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
		myText:setFillColor( 1, 0, 0, 1 )
		
		timer.performWithDelay( 3000, function()
			--destroy image
			if myText then
				myText:removeSelf()
				myText = nil
			end
		end)


		elseif event.done == "dummy" then
		print ("\nFILE FROM URI: " .. event.uri .. " Can be copied to Path :" .. event.destPath .. "with name: " .. event.destFileName .. " in a safe way")
		print ("\nThe file is : " .. event.size .. " Bytes Size. and has the original Name: " .. event.origFileName)

		end

		--list the directories
		listTempDirectory()
		listDocDirectory()



	elseif event.error then
		print ("\nERROR " .. event.error .. " With errorCode: " .. event.errorCode)
		print ("\nTrying to copy the file from the uri: " .. event.uri .. " To the path : " .. event.destPath)


		if event.errorCode == "2" then
			print ("\nThe User Refused to give permission to the app to get the file. Try again and give permission. It is safe!")

		elseif event.errorCode == "1" then
			print ("\nYou NEED to include the following at the build.settings file:")
			print ("\nandroid.permission.READ_EXTERNAL_STORAGE")
		end

	end

end




--receive the event and save the uri.
local function listener3( event )

	if event.done then

		if event.done == "ok" then
		print ("\nFILE COPIED TO " .. event.destPath .. " with name: " .. event.destFileName)
		print ("\nThe file is : " .. event.size .. " Bytes Size.")

		elseif event.done == "dummy" then
		print ("\nFILE FROM URI: " .. event.uri .. " Can be copied to Path :" .. event.destPath .. "with name: " .. event.destFileName .. " in a safe way")
		print ("\nThe file is : " .. event.size .. " Bytes Size. and has the original Name: " .. event.origFileName)

		print ("\nI will save the Uri for use it in Button 4 example ;)")
		print ("\nNote that no file has been copied. Was a dummy function used to get the Uri and details.")
		print ("\nWe can know with this method the size and other properties of a file prior to copy it to an internal dir.")
		print ("\nUse now the button 4 to copy the file from an Uri")

		myUri = event.uri --save the uri to use in the button 4 example


		local myText = display.newText( "Uri for File " .. event.destFileName .. " Saved !", display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
		myText:setFillColor( 1, 0, 0, 1 )
		

		timer.performWithDelay( 3000, function()
			--destroy image
			if myText then
				myText:removeSelf()
				myText = nil
			end
		end)


		end

		--list the directories
		listTempDirectory()
		listDocDirectory()


	elseif event.error then
		print ("\nERROR " .. event.error .. " With errorCode: " .. event.errorCode)
		print ("\nTrying to copy the file from the uri: " .. event.uri .. " To the path : " .. event.destPath)


		if event.errorCode == "2" then
			print ("\nThe User Refused to give permission to the app to get the file. Try again and give permission. It is safe!")

		elseif event.errorCode == "1" then
			print ("\nYou NEED to include the following at the build.settings file:")
			print ("\nandroid.permission.READ_EXTERNAL_STORAGE")
		end

	end

end




--positioning the buttons
local vS = display.contentHeight
local y1, y2, y3, y4 = (vS * .2), (vS * .4), (vS * .6), (vS * .8)
local x = display.contentWidth * .5




-- Create the widget
local button1 = widget.newButton(
    {
        x = x,
        y = y1,
        id = "button1",
        label = "Pick an image/*",
        onEvent = function (e)
        	if (e.phase == "ended") then
	        	print ("\nPick a File image/*, copy to TemporaryDirectory using pickFile(...), and open it")

	        	local path = system.pathForFile( nil, system.TemporaryDirectory )
				local fileName = nil -- fileName we want the copy will be named (String)
				local headerText = nil -- personalized dialog (String)
				local mimeType = "image/*" -- mimetype to filter
				local onlyOpenable = true --avoid non openable files
				local onlyDocuments = nil --open only documents filter
				local dumyMode = false --simulate the copy
	        	library.pickFile(path, listener1, fileName, headerText, mimeType, onlyOpenable, onlyDocuments, dumyMode )
	        end
    	end,
    }
)

-- Create the widget
local button2 = widget.newButton(
    {
        x = x,
        y = y2,
        id = "button2",
        label = "Pick a File */*",
        onEvent = function (e)
        	if (e.phase == "ended") then
	        	print ("\nPick a File */*, and copy it to DocomentsDirectory using pickFile(...)")

	        	local path = system.pathForFile( nil, system.DocumentsDirectory )
				local fileName = nil -- fileName we want the copy will be named (String)
				local headerText = nil -- personalized dialog (String)
				local mimeType = "*/*" -- mimetype to filter
				local onlyOpenable = true --avoid non openable files
				local onlyDocuments = nil --open only documents filter
				local dumyMode = false --simulate the copy
	        	library.pickFile(path, listener2, fileName, headerText, mimeType, onlyOpenable, onlyDocuments, dumyMode )
	        end
    	end,
    }
)


-- Create the widget
local button3 = widget.newButton(
    {
        x = x,
        y = y3,
        id = "button3",
        label = "Get the Uri from a File",
        onEvent = function (e)
        	if (e.phase == "ended") then
	        	print ("\nOnly get the Uri for a File */*, and save it to myUri Variable to use it later, using the pickFile(...). Note that no file will be copied. We use this only to get the Uri to use later.")

	        	--we will use the pickFile in dummy mode that only return the valid values.
	        	local path = system.pathForFile( nil, system.TemporaryDirectory )
				local fileName = nil -- fileName we want the copy will be named (String)
				local headerText = nil -- personalized dialog (String)
				local mimeType = "*/*" -- mimetype to filter
				local onlyOpenable = true --avoid non openable files
				local onlyDocuments = nil --open only documents filter
				local dumyMode = true --simulate the copy
	        	library.pickFile(path, listener3, fileName, headerText, mimeType, onlyOpenable, onlyDocuments, dumyMode )
	        end
    	end,
    }
)

-- Create the widget
local button4 = widget.newButton(
    {
        x = x,
        y = y4,
        id = "button4",
        label = "Get a File from Uri",
        onEvent = function (e)
        	if (e.phase == "ended") then

        		if myUri and myUri ~= "" then

	        		print ("\nUsing the saved myUri : \n" .. myUri .. "\n Get the file using the getFileFromUri(...)" )


		        	local path = system.pathForFile( nil, system.DocumentsDirectory ) --the path to copy the file to.
		        	local uri = myUri --the uri to get the file from.
					local fileName = nil -- fileName we want the copy will be named (String)
					local dumyMode = false --simulate the copy
		        	
					library.getFileFromUri(path, uri, listener2, fileName, dumyMode )

				else
					print ("\n--> There is no Uri recorded. Use first the button 3 to get a valid Uri.")

				end

	        end
    	end,
    }
)


-- END EXAMPLE --











