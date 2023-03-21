#!/usr/bin/env python3

import ctypes
import math
import unittest

# Str Utilities - Library

libstr = ctypes.CDLL('./libstr.so')

# Str Utilities - Test Case

class StrTestCase(unittest.TestCase):
    Total  = 7
    Points = 0

    def test_00_str_lower(self):
        words = [b'', b'abc', b'ABC', b'AbC']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.lower()
            libstr.str_lower(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 0.5 / len(words)

    def test_01_str_upper(self):
        words = [b'', b'abc', b'ABC', b'AbC']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.upper()
            libstr.str_upper(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 0.5 / len(words)
    
    def test_02_str_title(self):
        words = [b'', b'abc', b'ABC', b'AbC', b'a b c', b'aa b0b c!!c']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.title()
            libstr.str_title(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 1.25 / len(words)

    def test_03_str_chomp(self):
        words = [b'', b'\n', b'abc', b'abc\n', b'\nabc']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value
            while target and chr(target[-1]).isspace():
                target = target[:-1]
            libstr.str_chomp(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 0.5 / len(words)

    def test_04_str_strip(self):
        words = [b'', b' ', b' A', b'A ', b' A ', b' A B ']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value.strip()
            libstr.str_strip(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 1.0 / len(words)

    def test_05_str_reverse(self):
        words = [b'', b' ', b' A', b'A ', b' A ', b' A B ']
        for source in map(ctypes.create_string_buffer, words):
            target = source.value[::-1]
            libstr.str_reverse(source)
            self.assertTrue(source.value == target)
            StrTestCase.Points += 1.0 / len(words)
    
    def test_06_str_delete(self):
        cases = [
            (b'', b'', b''),
            (b'hello', b'', b'hello'),
            (b'hello', b'le', b'ho'),
            (b'hello world', b'le', b'ho word'),
        ]
        for s, fr, expected in cases:
            s = ctypes.create_string_buffer(s)
            libstr.str_delete(s, fr)
            self.assertTrue(s.value == expected)
            StrTestCase.Points += 1.0 / len(cases)

    def test_07_str_translate(self):
        cases = [
            (b'', b'', b'', b''),
            (b'hello', b'', b'430', b'hello'),
            (b'hello', b'aeo', b'', b'hello'),
            (b'hello', b'aeo', b'430', b'h3ll0'),
            (b' hello ', b'aeo', b'430', b' h3ll0 '),
            (b' hello ', b'aeol', b'4301', b' h3110 '),
        ]
        for s, fr, to, expected in cases:
            s = ctypes.create_string_buffer(s)
            libstr.str_translate(s, fr, to)
            self.assertTrue(s.value == expected)
            StrTestCase.Points += 1.25 / len(cases)

    @classmethod
    def setupClass(cls):
        cls.Points = 0

    @classmethod
    def tearDownClass(cls):
        print()
        print(f'   Score {cls.Points:0.2f} / {cls.Total:0.2f}')
        print(f'  Status {"Success" if math.isclose(cls.Points, cls.Total) else "Failure"}')

# Main Execution

if __name__ == '__main__':
    unittest.main()
