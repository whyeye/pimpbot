When sticking to a certain workflow, you can build an installer by simply dragging a folder with all your files on top of the PimpBot icon. We called this feature _DropFolder_.

To use _DropFolder_, you must stick to certain sensible defaults. This affects the structure of the data for the installer and naming conventions.

**/Name of my Pack**
<br>Topmost folder, directory name will be used for installer name.<br>
<br>
Everything following is inside of <i>/Name of my Pack</i>!<br>
<br>
<b>/avs</b>
<br>contains your presets, can be named_avs<i>,</i>milk<i>or</i>sps<br>
<br>
<b>/fonts</b>
contains all required fonts, can be TrueType or OpenType<br>
<br>
<b>/etc</b>
<br> contains your images, videos, colormaps, models etc.<br>
<br>
<b>license.txt</b>
<br>your license text, can be plaintext (<i>.txt</i>) or richtext (<i>.rtf</i>)<br>
<br>
<b>/ui</b>
<br>contains your interface resources, as listed below<br>
<br>
<b>checks.bmp</b>
<br>the bitmap for your installer checkboxes<br>
<br>
<b>icon.icon</b>
<br>the icon used for your installer<br>
<br>
<b>splash.bmp</b>
<br>image for your splash screen. file-name can be three-digit hexadecimal for alpha channel<br>
<br>e.g. <i>#f0f.bmp</i> (magenta == transparent)<br>
<br>
<b>splash.wav</b>
<br>wave sound for your splash screen. file-name can numerical for display lenght.<br>
<br>e.g. <i>4000.wav</i> (displays 4000 milliseconds or 4 seconds)<br>
<br>
<b>wizard.bmp</b>
<br>the image for your finish page<br>
<br>
For details, make sure to watch this <a href='http://vimeo.com/8446980'>video</a> on Vimeo!