package main

import (
	"AoC/day01"
	"AoC/day02"
	"fmt"
)

func main() {
	fmt.Println("==== AoC 2025 - Day 01 ====")
	day01 := day01.Run("day01/inputs/input.txt")
	fmt.Println("Part 1:", day01.ResetCount)
	fmt.Println("Part 2:", day01.Rotations)
	fmt.Printf("===========================\n\n")

	fmt.Println("==== AoC 2025 - Day 02 ====")
	part, part2 := day02.Run("day02/inputs/input.txt")
	fmt.Println("Part 1:", part)
	fmt.Println("Part 2:", part2)
	fmt.Printf("===========================\n\n")
}
