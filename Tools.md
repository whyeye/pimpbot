Hidden not-so-deep in your PimpBot install folder are a couple of scripts that might turn out to be useful for you. To use any of these, you need to compile them into binaries. As the installation of [NSIS](NSIS.md) is mandatory with any version of PimpBot, you should be set to go. All it takes is a right click on one of the scripts and choose "_Compile NSIS script_" from your context-menu.

Let take a look at these scripts:

**converter.nsi**<br>
Over the years, there were several changes to the structure of a <i>.pimp</i> file. This script will convert them to the latest standard. You might not need this, as PimpBot 4 converts outdated files by default.<br>
<br>
<b>migrator.nsi</b><br>
This script hasn't much to do with PimpBot, but it allows you to migrate your <a href='Winamp.md'>Winamp</a> installation to a multi-user environment. You migrate plugins, skins and/or your settings.<br>
<br>
<b>multitool.nsi</b><br>
If you need to update all your installers, this is probably the tool you're looking for. It allows the creation of executables from multiple <i>.pimp</i> files. You can compile installers using <a href='CommandlineParameters.md'>CommandlineParameters</a>.<br>
<br>
Besides the graphical intervace, you can also use PimpBot Multitool in textmode. Create a standard textfile, put the full path to a <i>.pimp</i> file in each line and drop it on the executable.<br>
<br>
<b>resourcegrab.nsi</b><br>
You want to rebuild an old installer, but don't have the sourcefiles anymore? Drop the installer on the ResourceGrab to extract icons, checkboxes and splash files. Requires <a href='http://www.angusj.com/resourcehacker/'>ResHacker</a> in the same directory, the parent directory or your <i>PimpBot\bin</i> folder.<br>
<br>
<b>settings.nsi</b><br>
Basically the same as a settings page in your installer as a standalone application.<br>
<br>
<del><b>zipntag.nsi</b></del><br>
Allows compressing multiple files and adding a text-file ("tag") to it. This function is also included in <i>Multitool</i>. Requires setting up some definitions in the header of the source-code.