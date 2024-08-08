USING System.Windows.Forms
USING System.Drawing
USING WMPLib

CLASS BasicForm INHERIT System.Windows.Forms.Form

	PROTECT oMoveBgTimer AS System.Windows.Forms.Timer
	PROTECT oLeftMoveTimer AS System.Windows.Forms.Timer
	PROTECT oRightMoveTimer AS System.Windows.Forms.Timer
	PROTECT oDownMoveTimer AS System.Windows.Forms.Timer
	PROTECT oUpMoveTimer AS System.Windows.Forms.Timer
	PROTECT oMoveMunitionsTimer AS System.Windows.Forms.Timer
	PROTECT oMoveEnemiesTimer AS System.Windows.Forms.Timer
	PROTECT oEnemyMunitionTimer AS System.Windows.Forms.Timer
	PROTECT oPauseTimer AS System.Windows.Forms.Timer
	PROTECT oStartGameTimer AS System.Windows.Forms.Timer
	PROTECT oLblPause AS System.Windows.Forms.Label
	PROTECT oLblScore AS System.Windows.Forms.Label
	PROTECT oPlayer AS System.Windows.Forms.PictureBox
	// User code starts here (DO NOT remove this line)  ##USER##
	PRIVATE nBackgroundSpeed AS INT
	PRIVATE nPlayerSpeed AS INT
	PRIVATE nMunitionSpeed AS INT
	PRIVATE oStars AS PictureBox[]
	PRIVATE oMunitions AS PictureBox[]
	PRIVATE oRandom := Random{} AS Random
	
	PRIVATE cShoot := System.IO.Path.Combine(Environment.CurrentDirectory, "laser.wav") AS STRING
	PRIVATE cExplosion := System.IO.Path.Combine(Environment.CurrentDirectory, "explosion.wav") AS STRING
	PRIVATE oShootMedia AS WindowsMediaPlayer 
	PRIVATE oExplosionMedia AS WindowsMediaPlayer
	
	PRIVATE nEnemySpeed := 4 AS INT
	PRIVATE oEnemies AS PictureBox[]
	PRIVATE bGameOver AS LOGIC
	
	PRIVATE oEnemiesMunition AS PictureBox[]
	PRIVATE nEnemiesMunitionSpeed AS INT
	PRIVATE nEnemyCounter AS INT
	PRIVATE nScore AS INT
	PRIVATE bPaused AS LOGIC 
	PRIVATE nStartingAt := 5 AS INT

	CONSTRUCTOR()
		SUPER()
		SELF:InitializeForm() 
	END CONSTRUCTOR

	METHOD InitializeForm() AS VOID
	
	// IDE generated code (please DO NOT modify)
	
		LOCAL oImagenesResourceManager AS System.Resources.ResourceManager

		oImagenesResourceManager := System.Resources.ResourceManager{ "Imagenes" , System.Reflection.Assembly.GetExecutingAssembly() }

		SELF:oMoveBgTimer := System.Windows.Forms.Timer{}
		SELF:oLeftMoveTimer := System.Windows.Forms.Timer{}
		SELF:oRightMoveTimer := System.Windows.Forms.Timer{}
		SELF:oDownMoveTimer := System.Windows.Forms.Timer{}
		SELF:oUpMoveTimer := System.Windows.Forms.Timer{}
		SELF:oMoveMunitionsTimer := System.Windows.Forms.Timer{}
		SELF:oMoveEnemiesTimer := System.Windows.Forms.Timer{}
		SELF:oEnemyMunitionTimer := System.Windows.Forms.Timer{}
		SELF:oPauseTimer := System.Windows.Forms.Timer{}
		SELF:oStartGameTimer := System.Windows.Forms.Timer{}
		SELF:oLblPause := System.Windows.Forms.Label{}
		SELF:oLblScore := System.Windows.Forms.Label{}
		SELF:oPlayer := System.Windows.Forms.PictureBox{}

		SELF:oMoveBgTimer:Enabled := TRUE
		SELF:oMoveBgTimer:Interval := 10
		SELF:oMoveBgTimer:Tick += SELF:MoveBgTimer_Tick

		SELF:oLeftMoveTimer:Interval := 5
		SELF:oLeftMoveTimer:Tick += SELF:LeftMoveTimer_Tick

		SELF:oRightMoveTimer:Interval := 5
		SELF:oRightMoveTimer:Tick += SELF:RightMoveTimer_Tick

		SELF:oDownMoveTimer:Interval := 5
		SELF:oDownMoveTimer:Tick += SELF:DownMoveTimer_Tick

		SELF:oUpMoveTimer:Interval := 5
		SELF:oUpMoveTimer:Tick += SELF:UpMoveTimer_Tick

		SELF:oMoveMunitionsTimer:Enabled := TRUE
		SELF:oMoveMunitionsTimer:Interval := 20
		SELF:oMoveMunitionsTimer:Tick += SELF:MoveMunitionsTimer_Tick

		SELF:oMoveEnemiesTimer:Enabled := TRUE
		SELF:oMoveEnemiesTimer:Interval := 100
		SELF:oMoveEnemiesTimer:Tick += SELF:MoveEnemiesTimer_Tick

		SELF:oEnemyMunitionTimer:Enabled := TRUE
		SELF:oEnemyMunitionTimer:Interval := 20
		SELF:oEnemyMunitionTimer:Tick += SELF:EnemyMunitionTimer_Tick

		SELF:oPauseTimer:Enabled := TRUE
		SELF:oPauseTimer:Interval := 1000
		SELF:oPauseTimer:Tick += SELF:PauseTimer_Tick

		SELF:oStartGameTimer:Enabled := FALSE
		SELF:oStartGameTimer:Interval := 1000
		SELF:oStartGameTimer:Tick += SELF:StartGameTimer_Tick

		SELF:SuspendLayout()

		SELF:BackColor := System.Drawing.Color.Navy
		SELF:ClientSize := System.Drawing.Size{600 , 500}
		SELF:FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog
		SELF:Icon := (System.Drawing.Icon)oImagenesResourceManager:GetObject( "icon.ico" )
		SELF:KeyDown += SELF:BasicForm_KeyDown
		SELF:KeyUp += SELF:BasicForm_KeyUp
		SELF:Load += SELF:BasicForm_Load
		SELF:Location := System.Drawing.Point{100 , 100}
		SELF:MaximumSize := System.Drawing.Size{600 , 500}
		SELF:MinimumSize := System.Drawing.Size{600 , 500}
		SELF:Name := "BasicForm"
		SELF:SizeGripStyle := System.Windows.Forms.SizeGripStyle.Hide
		SELF:StartPosition := System.Windows.Forms.FormStartPosition.CenterParent
		SELF:Text := "Space Shooter"

		SELF:oLblPause:AutoSize := FALSE
		SELF:oLblPause:BackColor := System.Drawing.Color.Transparent
		SELF:oLblPause:BorderStyle := System.Windows.Forms.BorderStyle.None
		SELF:oLblPause:Font := System.Drawing.Font{ "FFF Forward" , 21.75 , System.Drawing.FontStyle.Regular }
		SELF:oLblPause:ForeColor := System.Drawing.Color.FromArgb( 255,255,255 )
		SELF:oLblPause:Location := System.Drawing.Point{0 , 216}
		SELF:oLblPause:Name := "LblPause"
		SELF:oLblPause:Size := System.Drawing.Size{600 , 48}
		SELF:oLblPause:TabIndex := 2
		SELF:oLblPause:Text := "PAUSE"
		SELF:oLblPause:TextAlign := System.Drawing.ContentAlignment.TopCenter
		SELF:oLblPause:Visible := FALSE
		SELF:Controls:Add(SELF:oLblPause)
		
		SELF:oLblScore:AutoSize := TRUE
		SELF:oLblScore:BackColor := System.Drawing.Color.Transparent
		SELF:oLblScore:BorderStyle := System.Windows.Forms.BorderStyle.None
		SELF:oLblScore:Font := System.Drawing.Font{ "FFF Forward" , 12.0 , System.Drawing.FontStyle.Regular }
		SELF:oLblScore:ForeColor := System.Drawing.Color.FromArgb( 255,255,255 )
		SELF:oLblScore:Location := System.Drawing.Point{4 , 2}
		SELF:oLblScore:Name := "LblScore"
		SELF:oLblScore:Size := System.Drawing.Size{92 , 33}
		SELF:oLblScore:TabIndex := 1
		SELF:oLblScore:Text := "Score: 0"
		SELF:Controls:Add(SELF:oLblScore)
		
		SELF:oPlayer:BackColor := System.Drawing.Color.Transparent
		SELF:oPlayer:Image := (System.Drawing.Bitmap)oImagenesResourceManager:GetObject( "player.png" )
		SELF:oPlayer:Location := System.Drawing.Point{275 , 416}
		SELF:oPlayer:Name := "Player"
		SELF:oPlayer:Size := System.Drawing.Size{50 , 50}
		SELF:oPlayer:SizeMode := System.Windows.Forms.PictureBoxSizeMode.Zoom
		SELF:Controls:Add(SELF:oPlayer)
		
		SELF:ResumeLayout()

	END METHOD

	METHOD BasicForm_Load(sender AS System.Object , e AS System.EventArgs) AS VOID
		StartGame()
	END METHOD

	PRIVATE METHOD StartGame AS VOID

		bGameOver := FALSE
		bPaused := FALSE
	 
		nStartingAt := 5 // 5 seconds
		nBackgroundSpeed := 4
		nMunitionSpeed := 10
		nPlayerSpeed := 4
		nEnemySpeed := 4
		nEnemiesMunitionSpeed := 4
		nScore := 0
		oLblPause:Visible := FALSE
		oLblScore:Text := i"Score: {nScore}"

		// Player Location
		oPlayer:Location := Point{275 , 416}
		oPlayer:Visible := TRUE
		
		
		oStars := PictureBox[]{15}
		oMunitions := PictureBox[]{3}
		oRandom := Random{} 
		oShootMedia := WindowsMediaPlayer{}
		oShootMedia:URL := cShoot
		oShootMedia:settings:volume := 5
		
		oExplosionMedia := WindowsMediaPlayer{}
		oExplosionMedia:URL := cExplosion
		oExplosionMedia:settings:volume := 30 
		
		// enemies
		oEnemies := PictureBox[]{10}
		
		VAR oRM := System.Resources.ResourceManager{ "Imagenes" , System.Reflection.Assembly.GetExecutingAssembly() }
		LOCAL loEnemy1 := (System.Drawing.Bitmap)oRM:GetObject("E1.png") AS System.Drawing.Bitmap
		LOCAL loEnemy2 := (System.Drawing.Bitmap)oRM:GetObject("E2.png") AS System.Drawing.Bitmap
		LOCAL loEnemy3 := (System.Drawing.Bitmap)oRM:GetObject("E3.png") AS System.Drawing.Bitmap
		LOCAL loBoss1  := (System.Drawing.Bitmap)oRM:GetObject("Boss1.png") AS System.Drawing.Bitmap
		LOCAL loBoss2  := (System.Drawing.Bitmap)oRM:GetObject("Boss2.png") AS System.Drawing.Bitmap
		
		FOR VAR i:=1 TO 10
			oEnemies[i] := PictureBox{}			
			WITH oEnemies[i]
				:Size := Size{40, 40}
				:SizeMode := PictureBoxSizeMode.Zoom
				:BorderStyle := BorderStyle.None
				:Location := Point{i*50, -50}
				:Visible := FALSE
			END WITH
			Controls:Add(oEnemies[i])
		END FOR
		
		oEnemies[1]:Image := loBoss1
		oEnemies[2]:Image := loEnemy2
		oEnemies[3]:Image := loEnemy3
		oEnemies[4]:Image := loEnemy3
		oEnemies[5]:Image := loEnemy1
		oEnemies[6]:Image := loEnemy3
		oEnemies[7]:Image := loEnemy2
		oEnemies[8]:Image := loEnemy3
		oEnemies[9]:Image := loEnemy2
		oEnemies[10]:Image := loBoss2				

		// spawn munitions
		FOR VAR i:=1 TO oMunitions.Length
			IF oMunitions[i] == NULL
				oMunitions[i] := PictureBox{}
			ENDIF
			oMunitions[i]:Image := (System.Drawing.Bitmap)(Bitmap)oRM:GetObject("munition.png")
			oMunitions[i]:Size := Size{8,8}
			oMunitions[i]:SizeMode := PictureBoxSizeMode.Zoom
			oMunitions[i]:BorderStyle := BorderStyle.None
			oMunitions[i]:Visible := TRUE
			oMunitions[i]:Location := Point{oPlayer:Location:X + 20, oPlayer:Location:Y - i * 30}			
			Controls:Add(oMunitions[i])
		END FOR
		
		// spawn stars
		FOR VAR i:=1 TO oStars.length
			IF oStars[i] == NULL
				oStars[i] := PictureBox{}
			ENDIF
			WITH oStars[i]
				:BorderStyle := BorderStyle.None
				:Top := -oRandom:Next(1, 500)
				:Left := oRandom:Next(10, Width-10)
				IF i%2 == 1
					:Size := System.Drawing.Size{2, 2}
					:BackColor := Color.Wheat
				ELSE
					:Size := System.Drawing.Size{3, 3}
					:BackColor := Color.DarkGray
				ENDIF
			END WITH
			Controls:Add(oStars[i])
		END FOR
		
		// Enemies Munition
		oEnemiesMunition := PictureBox[]{10}
		FOR VAR i:=1 TO oEnemiesMunition.Length
			IF oEnemiesMunition[i] == NULL
				oEnemiesMunition[i] := PictureBox{}
			ENDIF
			WITH oEnemiesMunition[i]
				:Size := Size{2, 25}
				:Visible := TRUE
				:BackColor := Color.Yellow
				LOCAL lnRandomEnemy := oRandom:Next(1, 10) AS INT
				:Location := Point{oEnemies[lnRandomEnemy]:Location:X, oEnemies[lnRandomEnemy]:Location:Y-20}
			END WITH
			Controls:Add(oEnemiesMunition[i])
		END FOR
	END METHOD


	METHOD MoveBgTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID	
		  FOR VAR i:=1 TO 10
			oStars[i]:Top += oRandom:Next(1, nBackgroundSpeed)
		  	IF oStars[i]:Top >= Height
		  		oStars[i]:Left := oRandom:Next(10, Width-10)
		  		oStars[i]:Top := -oRandom:Next(1, 500)
		  	ENDIF
		  END FOR
	END METHOD


	METHOD LeftMoveTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		IF oPlayer:Left > 10
			oPlayer:Left -= nPlayerSpeed
		ENDIF
	END METHOD


	METHOD RightMoveTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		IF oPlayer:Right < Width-15
			oPlayer:Left += nPlayerSpeed
		ENDIF
	END METHOD


	METHOD DownMoveTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		IF oPlayer:Bottom < Height-35
			oPlayer:Top += nPlayerSpeed
		ENDIF
	END METHOD


	METHOD UpMoveTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		IF oPlayer:Top > 10
			oPlayer:Top -= nPlayerSpeed
		ENDIF
	END METHOD


	METHOD BasicForm_KeyDown(sender AS System.Object , e AS System.Windows.Forms.KeyEventArgs) AS VOID
		IF e:KeyCode == Keys.Left
			oLeftMoveTimer:Start()
		ENDIF
		IF e:KeyCode == Keys.Right
			oRightMoveTimer:Start()
		ENDIF
		IF e:KeyCode == Keys.Up
			oUpMoveTimer:Start()
		ENDIF
		IF e:KeyCode == Keys.Down
			oDownMoveTimer:Start() 
		ENDIF
	END METHOD


	METHOD BasicForm_KeyUp(sender AS System.Object , e AS System.Windows.Forms.KeyEventArgs) AS VOID
		IF e:KeyCode == Keys.Left && !bPaused
			oLeftMoveTimer:Stop()
		ENDIF
		IF e:KeyCode == Keys.Right && !bPaused
			oRightMoveTimer:Stop()
		ENDIF
		IF e:KeyCode == Keys.Up && !bPaused
			oUpMoveTimer:Stop()
		ENDIF
		IF e:KeyCode == Keys.Down && !bPaused
			oDownMoveTimer:Stop()
		ENDIF		
		IF e:KeyCode == Keys.Space && !bGameOver
			bPaused := !bPaused
			oLblPause:Visible := bPaused
		ENDIF
	END METHOD


	METHOD MoveMunitionsTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID		
		IF bPaused
			RETURN
		ENDIF
		IF !bGameOver
			oShootMedia:controls:play()
			CheckCollision()
			FOR VAR i:=1 TO oMunitions.Length
				IF oMunitions[i]:Top > 0
					oMunitions[i]:Visible := TRUE				
					oMunitions[i]:Top -= nMunitionSpeed
				ELSE
					oMunitions[i]:Visible := FALSE					
					oMunitions[i]:Left := oPlayer:Left + oPlayer:Width/2 - oMunitions[i]:Width/2
					oMunitions[i]:Top := oPlayer:Top
				ENDIF
			END FOR
		ELSE 
			FOR VAR i:=1 TO oMunitions.Length
				IF oMunitions[i]:Top > 0
					oMunitions[i]:Visible := TRUE				
					oMunitions[i]:Top -= nMunitionSpeed
				ENDIF
			END FOR			
		ENDIF
	END METHOD


	METHOD MoveEnemiesTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		IF bPaused
			RETURN
		ENDIF
		MoveEnemies()
	END METHOD

	
	METHOD MoveEnemies AS VOID
		FOR VAR i:= 1 TO oEnemies.Length
			oEnemies[i]:Visible := TRUE
			oEnemies[i]:Top += nEnemySpeed
			IF oEnemies[i]:Top > Height
			    
				// if 10 enemies pass through the player
				// then increase the enemies speed
				nEnemyCounter++
				IF nEnemyCounter >= 10
					nEnemyCounter := 0
					nEnemySpeed++
				ENDIF
				
				oEnemies[i]:Location := Point{i*50, -200}
			ENDIF
		END FOR
	END METHOD


	PRIVATE METHOD CheckCollision AS VOID
		IF bPaused
			RETURN
		ENDIF
		FOR VAR i:=1 TO oEnemies.Length
			FOR VAR j:=1 TO oMunitions.Length
				// check if any bullet collides with an enemy
				IF oMunitions[j]:Bounds:IntersectsWith(oEnemies[i]:Bounds)
					oExplosionMedia:controls:play()
					oEnemies[i]:Location := Point{i*50, -100}
					nScore++
					oLblScore:Text := i"Score: {nScore}"
				ENDIF
			END FOR
			
			// check if the player hits one enemy
			IF oPlayer:Bounds:IntersectsWith(oEnemies[i]:Bounds)				
				oExplosionMedia:controls:play()
				oPlayer:Visible := FALSE
				GameOver()				
			ENDIF
		END FOR
		
		// Check if any enemies munition hits the player
		FOR VAR i:=1 TO oEnemiesMunition.Length
			IF oEnemiesMunition[i]:Bounds:IntersectsWith(oPlayer:Bounds)
				oExplosionMedia:controls:play()
				oPlayer:Visible := FALSE				
				GameOver()
			ENDIF
		END FOR
	END METHOD
	
	PRIVATE METHOD GameOver AS VOID
		bGameOver := TRUE		
		oMoveBgTimer:Stop()
		oStartGameTimer:Start()
		//oMoveMunitionsTimer:Stop()
	END METHOD
	

	METHOD EnemyMunitionTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		IF bPaused
			RETURN
		ENDIF
		FOR VAR i:=1 TO oEnemiesMunition.Length             
			IF oEnemiesMunition[i]:Top < Height
				oEnemiesMunition[i]:Visible := TRUE
				oEnemiesMunition[i]:Top += nEnemiesMunitionSpeed
			ELSE
				oEnemiesMunition[i]:Visible := FALSE
				LOCAL lnRandomEnemy := oRandom:Next(1, 10) AS INT
				oEnemiesMunition[i]:Location := Point{oEnemies[lnRandomEnemy]:Location:X, oEnemies[lnRandomEnemy]:Location:Y-20}
			ENDIF
		END FOR
	END METHOD

	METHOD PauseTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		IF bPaused
			oLblPause:Visible := !oLblPause:Visible
		ENDIF
	END METHOD


	METHOD StartGameTimer_Tick(sender AS System.Object , e AS System.EventArgs) AS VOID
		nStartingAt--
		oLblPause:Visible := TRUE
		oLblPause:Text := i"{nStartingAt}"
		IF nStartingAt == 0
			oStartGameTimer:Stop()
			oStartGameTimer:Enabled := FALSE
			
			// drop all enemies
			FOR VAR i:=1 TO oEnemies.Length
				oEnemies[i]:Dispose()
				Controls:Remove(oEnemies[i])
				oEnemies[i] := NULL
			END FOR
			
			// drop all enemies bullets
			FOR VAR i:=1 TO oEnemiesMunition.Length
				oEnemiesMunition[i]:Dispose()
				Controls:Remove(oEnemiesMunition[i])
				oEnemiesMunition[i] := NULL
			END FOR
						

			StartGame()
		ENDIF
	END METHOD


END CLASS

