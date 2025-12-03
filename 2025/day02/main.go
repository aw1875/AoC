package day02

import (
	"bufio"
	"log"
	"os"
	"strconv"
	"strings"
)

type ProductRange struct {
	StartId int
	EndId   int
}

func parseProductRange(rangeStr string) *ProductRange {
	parts := strings.Split(rangeStr, "-")
	start, _ := strconv.Atoi(strings.TrimSpace(parts[0]))
	end, _ := strconv.Atoi(strings.TrimSpace(parts[1]))

	return &ProductRange{StartId: start, EndId: end}
}

func hasRepeatedSequence(n int) bool {
	s := strconv.Itoa(n)
	length := len(s)

	for patternLen := 1; patternLen < length; patternLen++ {
		if length%patternLen == 0 {
			pattern := s[:patternLen]
			if strings.Repeat(pattern, length/patternLen) == s {
				return true
			}
		}
	}

	return false
}

func partOne(productIds []*ProductRange) int {
	result := 0

	for _, pr := range productIds {
		for id := pr.StartId; id <= pr.EndId; id++ {
			s := strconv.Itoa(id)
			mid := len(s) / 2

			if s[:mid] == s[mid:] {
				result += id
			}
		}
	}

	return result
}

func partTwo(productIds []*ProductRange) int {
	result := 0

	for _, pr := range productIds {
		for id := pr.StartId; id <= pr.EndId; id++ {
			if hasRepeatedSequence(id) {
				result += id
			}
		}
	}

	return result
}

func Run(filePath string) (int, int) {
	file, err := os.Open(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Scan()

	var productIds []*ProductRange
	for rangeStr := range strings.SplitSeq(scanner.Text(), ",") {
		productIds = append(productIds, parseProductRange(rangeStr))
	}

	return partOne(productIds), partTwo(productIds)
}
