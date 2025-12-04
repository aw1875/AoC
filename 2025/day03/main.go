package day03

import (
	"bufio"
	"log"
	"os"
	"strconv"
)

func findMaxNumber(line string, digits int) int {
	result := make([]byte, 0, digits)

	for i := range digits {
		end := len(line) - (digits - i - 1)

		maxDigit, maxIndex := byte('0'-1), -1
		for j := range end {
			if line[j] > maxDigit {
				maxDigit = line[j]
				maxIndex = j
			}
		}

		result = append(result, maxDigit)
		line = line[maxIndex+1:]
	}

	max, _ := strconv.Atoi(string(result))
	return max
}

func Run(filePath string) (int, int) {
	file, err := os.Open(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	part1, part2 := 0, 0

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()

		part1 += findMaxNumber(line, 2)
		part2 += findMaxNumber(line, 12)
	}

	return part1, part2
}
