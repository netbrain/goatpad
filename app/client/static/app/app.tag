require('normalize.css')
require('skeleton')

require('./menu.tag')
require('./editor.tag')
 
<app>
	<menu></menu><editor></editor>

	<style>
		* {
			margin: 0px;
		}
		menu {
			padding: 0px;
			display: inline-block;
			width: 20%;
		}
		editor {
			display: inline-block;
			width: 80%;
		}
	</style>
</app>
