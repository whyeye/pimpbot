## PimpBot Compiler ##
**/help -?**
<br>shows program version and a list of available commandline switches<br>
<br>
<b>/defaults</b>
<br>allows the customization of default settings, saved in <i>%APPDATA%\PimpBot\defaults.ini</i>

<b>/detectape -da</b>
<br>renamed to <b>/scanape</b> as of PimpBot 4.2<br>
<br>
<b>/flush</b>
<br>reset PimpBot to its default settings<br>
<br>
<b>/loaddir -ld</b>
<br>load files from a directory; directory must follow sensible defaults<br>
<br>e.g. <i>/loaddir="C:\My Directory"</i>

<b>/loadfile -lf</b>
<br>load a .pimp file, can be combined with the <i>/passive</i> command<br>
<br>e.g. <i>/loadfile="C:\path\to\myfile.pimp"</i>

<b>/loadui -ui</b>
<br>load a custom UI file, automatically detects standard and modern UI files<br>
<br>e.g. <i>/loadui="C:\Path\to\\My UI.exe"</i>
<br>e.g. <i>/loadui="sdbarker_tiny.exe"</i>

<b>/noavs -na</b>
<br>PimpBot creates an installer that requires no presets, useful for "resource packs" (textures, filters, colormaps etc.)<br>
<br>e.g. <i>/noavs=1</i>

<b>/noexe -nx</b>
<br>PimpBot skips making an installer, but creates a .pimp file<br>
<br>e.g. <i>/noexe=1</i>

<b>/nolegacy -nl</b>
<br>PimpBot will only include APEs for Winamp 5 and later (not recommended)<br>
<br>e.g. <i>/nolegacy=1</i>

<b>/nomui -nm</b>
<br>will use the default NSIS UI instead of Modern UI, does not support settings page or wizard image<br>
<br>e.g. <i>/nomui=1</i>

<b>/noout -no</b>
<br>skips creation of installer and <i>.pimp</i> file (for developers)<br>
<br>e.g. <i>/noout=1</i>

<b>/nopimp -np</b>
<br>PimpBot creates an installer, but skips the <i>.pimp</i> file<br>
<br>e.g. <i>/nopimp=1</i>

<b>/outdir -od</b>
<br>override the default output directory, requires a valid directory<br>
<br>e.g. <i>/output="C:\My Directory"</i>

<b>/outfile -of</b>
<br>override the default output filename, requires a valid directory<br>
<br>e.g. <i>/output="I like this Name"</i>

<b>/passive -pv</b>
<br>used with the <i>/loadfile</i> command, this will compile an installer silently<br>
<br>e.g. <i>/loadfile="C:\path\to\myfile.pimp" /passive=1</i>

<b>/portable -pt</b>
<br>sets up PimpBot for portable mode, copying settings file to %PROGRAMFILES%<br>
<br>e.g. <i>/portable=1</i>

<b>/scanape -sa</b>
<br>used with the <i>/loadfile</i> command, this will detect required APEs<br>
<br>e.g. <i>/loadfile="C:\path\to\myfile.pimp" /scanape=1</i>

<b>/scanres -sr</b>
<br>used with the <i>/loadfile</i> command, this will detect required resource files (images, videos etc.)<br>
<br>e.g. <i>/loadfile="C:\path\to\myfile.pimp" /scanres=1</i>

<b>/script -ls</b>
<br>makes PimpBot use a custom NSIS template, rather than its internal script (for developers)<br>
<br>e.g. <i>/script="C:\Path\to\My Script.nsi"</i>

<b>/waskin -ws</b>
<br>injects a Winamp skin to the installer, can be installed optionally<br>
<br>e.g. <i>/waskin="C:\Path\to\My Skin.wsz"</i>

<b>/ziptag -zt</b>
<br>compresses installer and adds a tag-file to it<br>
<br>e.g. <i>/ziptag="C:\Path\to\My Tag.diz"</i>

<hr />

<h2>Installer</h2>
<b>/help -?</b>
<br>shows a list of available commandline switches<br>
<br>
<b>/debug</b>
<br>displays extra information during installation<br>
<br>
<b>/details</b>
<br>forces an installer to verbose mode to review its actions<br>
<br>
<b>/lang</b>
<br>allows the selection of an installer language (multilingual installers only)<br>
<br>
<b>/nocheck</b>
<br>disables the validation of the Winamp directory, useful for third-party players (e.g. <i>foobar2000</i>)<br>
<br>
<b>/nosplash</b>
<br>disables splash screen<br>
<br>
<b>/oldmilk</b>
<br>forces installer using legacy MilkDrop<br>
<br>
<b>/unzip</b>
<br>extracts the contents of the installer to the current directory<br>
<br>
<b>/D</b>
<br>overrides target directory; case-sensitive switch, <a href='NSIS.md'>NSIS</a> default<br>
<br>e.g. <i>/D=C:\Program Files\Winamp</i>

<b>/S</b>
<br>runs the installer silenty; case-sensitive switch, <a href='NSIS.md'>NSIS</a> default<br>
<br>
<hr />

<h2>PimpBot Backup</h2>
<b>/help -?</b>
<br>shows program version and a list of available commandline switches<br>
<br>
<b>/flush</b>
<br>reset PimpBot Backup to its default settings<br>
<br>
<b>/loadfile -lf</b>
<br>load a .pimp file<br>
<br>e.g. <i>/loadfile="C:\path\to\myfile.pimp"</i>

<hr />

<h2>PimpBot Runtime</h2>
<b>/help -?</b>
<br>shows program version and a list of available commandline switches<br>
<br>
<b>/loadfile -lf</b>
<br>load a .pimp file<br>
<br>e.g. <i>/loadfile="C:\path\to\myfile.pimp"</i>

<b>/details -sd</b>
<br>forces an installer to verbose mode to review its actions<br>
<br>e.g. <i>/details=1</i>

<b>/nodetails -nd</b>
<br>forces an installer to quiet mode<br>
<br>e.g. <i>/nodetails=1</i>

<b>/nosplash -ns</b>
<br>disables splash screen<br>
<br>e.g. <i>/nosplash=1</i>