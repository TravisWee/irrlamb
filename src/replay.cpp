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
#include <replay.h>
#include <save.h>
#include <log.h>
#include <config.h>
#include <constants.h>
#include <level.h>
#include <game.h>
#include <sstream>

_Replay Replay;

// Start recording a replay
void _Replay::StartRecording() {
	if(State != STATE_NONE)
		return;

	// Set up state
	State = STATE_RECORDING;
	NextPacketTime = 1.0f;
	Time = 0;

	// Get header information
	ReplayVersion = REPLAY_VERSION;
	LevelVersion = Level.LevelVersion;
	LevelName = Level.LevelName;

	// Create replay file for object data
	ReplayDataFile = Save.ReplayPath + "replay.dat";
	File.open(ReplayDataFile.c_str(), std::ios::out | std::ios::binary);
	if(!File.is_open())
		Log.Write("_Replay::StartRecording - Unable to open %s!", ReplayDataFile.c_str());
}

// Stops the recording process
void _Replay::StopRecording() {

	if(State == STATE_RECORDING) {
		State = STATE_NONE;
		File.close();
		remove(ReplayDataFile.c_str());
	}
}

// Saves the current replay out to a file
bool _Replay::SaveReplay(const std::string &PlayerDescription, bool Autosave) {
	Description = PlayerDescription;
	TimeStamp = time(nullptr);
	FinishTime = Time;

	// Flush current replay file
	File.flush();

	// Get new file name
	std::stringstream ReplayFilePath;
	ReplayFilePath << Save.ReplayPath << (uint32_t)TimeStamp << ".replay";

	// Open new file
	std::fstream NewFile(ReplayFilePath.str().c_str(), std::ios::out | std::ios::binary);
	if(!NewFile) {
		Log.Write("_Replay::SaveReplay - Unable to open %s for writing!", ReplayFilePath.str().c_str());
		return false;
	}

	// Write replay version
	WriteChunk(NewFile, PACKET_REPLAYVERSION, (char *)&ReplayVersion, sizeof(ReplayVersion));

	// Write level version
	WriteChunk(NewFile, PACKET_LEVELVERSION, (char *)&LevelVersion, sizeof(LevelVersion));

	// Write timestep value
	WriteChunk(NewFile, PACKET_TIMESTEP, (char *)&Game.GetTimeStep(), sizeof(Game.GetTimeStep()));

	// Write level file
	WriteChunk(NewFile, PACKET_LEVELFILE, LevelName.c_str(), LevelName.length());

	// Write player's description of replay
	WriteChunk(NewFile, PACKET_DESCRIPTION, Description.c_str(), Description.length());

	// Write time stamp
	WriteChunk(NewFile, PACKET_DATE, (char *)&TimeStamp, sizeof(TimeStamp));

	// Write finish time
	WriteChunk(NewFile, PACKET_FINISHTIME, (char *)&FinishTime, sizeof(FinishTime));

	// Write autosave value
	WriteChunk(NewFile, PACKET_AUTOSAVE, (char *)&Autosave, sizeof(Autosave));

	// Finished with header
	NewFile.put(PACKET_OBJECTDATA);
	uint32_t Dummy = 0;
	NewFile.write((char *)&Dummy, sizeof(Dummy));

	// Copy current data to new replay file
	std::ifstream CurrentReplayFile(ReplayDataFile.c_str(), std::ios::in | std::ios::binary);
	char Buffer[4096];
	std::streamsize BytesRead;
	while(!CurrentReplayFile.eof()) {
		CurrentReplayFile.read(Buffer, 4096);
		BytesRead = CurrentReplayFile.gcount();

		if(BytesRead)
			NewFile.write(Buffer, (uint32_t)BytesRead);
	}

	CurrentReplayFile.close();
	NewFile.close();

	return true;
}

// Load header data
void _Replay::LoadHeader() {
	bool Debug = false;

	// Write replay version
	char PacketType;
	uint32_t PacketSize;
	bool Done = false;
	char Buffer[1024];
	while(!File.eof() && !Done) {
		PacketType = File.get();
		File.read((char *)&PacketSize, sizeof(PacketSize));
		switch(PacketType) {
			case PACKET_REPLAYVERSION:
				File.read((char *)&ReplayVersion, PacketSize);
				if(ReplayVersion != REPLAY_VERSION)
					Done = true;

				if(Debug)
					Log.Write("ReplayVersion=%d, PacketSize=%d", ReplayVersion, PacketSize);
			break;
			case PACKET_LEVELVERSION:
				File.read((char *)&LevelVersion, PacketSize);

				if(Debug)
					Log.Write("LevelVersion=%d, PacketSize=%d", LevelVersion, PacketSize);
			break;
			case PACKET_LEVELFILE:
				File.read(Buffer, PacketSize);
				Buffer[PacketSize] = 0;
				LevelName = Buffer;

				if(Debug)
					Log.Write("LevelName=%s, PacketSize=%d", Buffer, PacketSize);
			break;
			case PACKET_DESCRIPTION:
				File.read(Buffer, PacketSize);
				Buffer[PacketSize] = 0;
				Description = Buffer;

				if(Debug)
					Log.Write("Description=%s, PacketSize=%d", Buffer, PacketSize);
			break;
			case PACKET_DATE:
				File.read((char *)&TimeStamp, PacketSize);

				if(Debug)
					Log.Write("TimeStamp=%d, PacketSize=%d", TimeStamp, PacketSize);
			break;
			case PACKET_FINISHTIME:
				File.read((char *)&FinishTime, PacketSize);

				if(Debug)
					Log.Write("FinishTime=%f, PacketSize=%d", FinishTime, PacketSize);
			break;
			case PACKET_AUTOSAVE:
				Autosave = File.get();

				if(Debug)
					Log.Write("Autosave=%d, PacketSize=%d", Autosave, PacketSize);
			break;
			case PACKET_OBJECTDATA:
				Done = true;
			break;
			default:
				File.ignore(PacketSize);
			break;
		}
	}
}

// Write a replay chunk
void _Replay::WriteChunk(std::fstream &OutFile, char Type, const char *Data, uint32_t Size) {
   OutFile.put(Type);
   OutFile.write((char *)&Size, sizeof(Size));
   OutFile.write(Data, Size);
}

// Updates the replay timer
void _Replay::Update(float FrameTime) {
	Time += FrameTime;
	NextPacketTime += FrameTime;
}

// Determines if a packet is required
bool _Replay::NeedsPacket() {

	return State == STATE_RECORDING;
}

// Resets the next packet timer
void _Replay::ResetNextPacketTimer() {

	if(NeedsPacket())
		NextPacketTime = 0;
}

// Starts replay
bool _Replay::LoadReplay(const std::string &ReplayFile, bool HeaderOnly) {
	LevelName = "";
	LevelVersion = 0;
	ReplayVersion = 0;

	// Get file name
	std::string FilePath = Save.ReplayPath + ReplayFile;

	// Open the replay
	File.open(FilePath.c_str(), std::ios::in | std::ios::binary);
	if(!File)
		return false;

	// Read header
	LoadHeader();

	// Read only the header
	if(HeaderOnly)
		File.close();

	return true;
}

// Stops replay
void _Replay::StopReplay() {

	State = STATE_NONE;
	File.close();
}

// Returns true if the replay is done playing
bool _Replay::ReplayStopped() {

	return File.eof();
}

// Write replay event
void _Replay::WriteEvent(uint8_t Type) {
	File.put(Type);
	File.write((char *)&Time, sizeof(Time));
}

// Reads a packet header
void _Replay::ReadEvent(ReplayEventStruct &Packet) {
	Packet.Type = File.get();
	File.read((char *)&Packet.TimeStamp, sizeof(Packet.TimeStamp));
}
