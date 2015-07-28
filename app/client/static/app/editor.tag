<editor>
	<canvas id="canvasElement"></canvas>

	<style scoped>
	canvas {
		display: block;
 		height: 100vh; 
  		width: 100vw; 
	}
	</style>
	<script>
		class Caret {
			constructor(editor){
				this.editor = editor;
				
				this.x = 0;
				this.y = 0;
				this.col = 0;
				this.row = 0;

				var _this = this;
				this.interval = setInterval(function(){
					_this.visible = !_this.visible;
					_this.draw()
				},750)
			}

			incrementCol(){
				var ch = this.editor.text.getCharAt(this.row,this.col);
				this.x = ch.x+ch.width;
				this.y = ch.y;
				console.log(ch);
				this.col++;
					
			}

			decrementCol(){
				this.col--;
				var ch = this.editor.text.getCharAt(this.row,this.col);
				this.x = ch.x;
				this.y = ch.y;
			}

			incrementRow(){
				var ch = this.editor.text.getCharAt(this.row,this.col);
				this.x = ch.x;
				this.y = ch.y;
				this.row++;
				this.col = 0;
					
			}

			decrementRow(){
				this.row--;
				this.col = this.text[this._row()].length-1;
				var ch = this.editor.text.getCharAt(this.row,this.col);
				this.x = ch.x;
				this.y = ch.y;
			}

			draw(){
				this.editor.ctx.clearRect(this.x, this.y, 1, this.y+20);
				if (this.visible){
					this.editor.ctx.beginPath();
					this.editor.ctx.moveTo(this.x,this.y);
					this.editor.ctx.lineTo(this.x,this.y+20);
					this.editor.ctx.strokeStyle="black";
					this.editor.ctx.stroke();
				}				
			}

			stop(){
				clearInterval(this.interval);
			}
		}

		class EditorTextCharacter{
			constructor(editor,textMap,row,col,ch){
				this.editor = editor;
				this.textMap = textMap;
				this.row = row;
				this.col = col;
				this.ch = ch;

				var x,y,width;
				var prev = this.getPrevChar();
				if(prev){
					x = prev.x;
					y = prev.y;
					width = prev.width;
				}else{
					x = 0;
					y = 20; //TODO replace with fontsize
					width = 0;
				}

				var measure = this.editor.ctx.measureText(this.ch);
				this.width = measure.width;

				if(prev && prev.ch === '\n'){
					this.x = 0;
					this.y = y + 20 //TODO replace with fontsize / linesize
				}else{
					this.x = x+width;
					this.y = y;
				}
			}

			getNextChar(){
				if(this.textMap[this.row]){
					if(this.textMap[this.row][this.col+1]){
						return this.textMap[this.row][this.col+1];
					}else if (this.textMap[this.row+1]){
						return this.textMap[this.row+1][0];
					}
				}
				return undefined;
			}

			getPrevChar(){
				if(this.textMap[this.row]){
					if(this.textMap[this.row][this.col-1]){
						return this.textMap[this.row][this.col-1];
					}else if (this.textMap[this.row-1]){
						return this.textMap[this.row-1][this.textMap[this.row-1].length-1];
					}
				}
				return undefined;
			}

			hasBeenDrawed(){
				return this.x !== undefined && this.y !== undefined;
			}

			draw(){
				console.log("draw:"+this.ch+" @ x:"+this.x+", y:"+this.y);
				this.editor.ctx.fillText(this.ch,this.x,this.y);
			}
		}

		class EditorText {
			constructor(editor){
				this.editor = editor;
				this.text = []
				this.font = {
					size: 20,
					type: 'Georgia',
				}
			}

			draw(){
				this.editor.ctx.font=this.font.size+"pt "+this.font.type;

				for(var row = 0; row < this.text.length; row++){
					for(var col = 0; col < this.text[row].length; col++){
						this.text[row][col].draw();
					}	
				}

			}

			backspace(){
				this.editor.caret.decrementCol();
			    this.text[this._row()].splice(this._col(),1);
				
				if(this._col() === -1){
					if(this._row() === 0){
						this.editor.caret.incrementCol();
						return;
					}
					this.editor.caret.decrementRow();
				}			
			}

			breakLine(){
				this.editor.caret.incrementRow();
				this.insertChar('\n');
			}

			insertChar(ch){
				if(ch.length != 1){
					throw "invalid length";
				}

				if (!this.text[this._row()]){
					this.text[this._row()] = [];	
				}
				this.text[this._row()][this._col()] = new EditorTextCharacter(
					this.editor,
					this.text,
					this._row(),
					this._col(),
					ch
				);
				this.editor.caret.incrementCol();
			}

			getCharAt(row,col){
				if(this.text && this.text[row] && this.text[row][col]){
					return this.text[row][col];	
				}
				return undefined;
			}

			_row(){
				return this.editor.caret.row;
			}

			_col(){
				return this.editor.caret.col;
			}

		}

		class Editor{
			constructor(canvas){
				this.elem = canvas,
				this.ctx = canvas.getContext('2d');
				this.caret = new Caret(this);
				this.text = new EditorText(this,this.caret);

				var _this = this;
				/*this.interval = setInterval(function(){
					_this.draw();
				},100);*/
			}

			draw(){
				this.ctx.clearRect(0, 0, this.elem.width, this.elem.height);
  				this.ctx.canvas.width  = window.innerWidth;
  				this.ctx.canvas.height = window.innerHeight;
	    		this.caret.draw()
	    		this.text.draw();
				this.ctx.fillText(this.lastKeycode,10,100);
			}

			type(keycode){
				this.lastKeycode = keycode;

				switch(keycode){
					case 8: //BACKSPACE
						this.text.backspace();
						break;
					case 13: //ENTER
						this.text.breakLine();
						break;
					default:
						this.text.insertChar(String.fromCharCode(keycode));
						break;
				}

			}

			stop(){
				clearInterval(this.interval);
			}
		}

		var editor = new Editor(this.canvasElement);

		document.onkeypress = function(e){
			console.log(e)
			//editor.type(event.which || event.keyCode)
		}

		document.onkeypress = function(e){
			editor.type(event.which || event.keyCode)
			editor.draw();
		}

		</script>
</editor>