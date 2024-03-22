package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	fmt.Println("Starting, downloading video ...")

	downloadYoutubeVideo("https://www.youtube.com/watch?v=0dG7UIWu2ik")

	fmt.Println("Done")
}

func downloadYoutubeVideo(rawUrl string) {
	args := []string{"-x", "-f", "bestaudio", "--audio-format", "mp3", "-o", "/resources/good_speech.mp3", rawUrl}

	// Create a new cmd instance
	cmd := exec.Command("yt-dlp", args...)

	// Set stdout and stderr for the command
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	// Run the command
	err := cmd.Run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error executing command: %s\n", err)
		os.Exit(1)
	}
}
