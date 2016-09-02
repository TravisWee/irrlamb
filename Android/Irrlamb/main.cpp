/******************************************************************************
* irrlamb - https://github.com/jazztickets/irrlamb
* Copyright (C) 2015  Alan Witkowski
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*******************************************************************************/


#include <game.h>


#ifdef _IRR_ANDROID_PLATFORM_

#include <android_native_app_glue.h>
#include "android_tools.h"
#include "android/window.h"



/* Main application code. */
void android_main(android_app* app)
{
	char* Arguments[3] = {"Irrlamb", "-path", const_cast<char*>(app->activity->internalDataPath)};
	// Make sure glue isn't stripped.
	app_dummy();
	
	// Initialize the game
	if(!Game.Init(3, Arguments))
		return;

	// Main game loop
	while(!Game.IsDone()) {

		Game.Update();
	}

	// Shut down the system
	Game.Close();

}

#endif	// defined(_IRR_ANDROID_PLATFORM_)

