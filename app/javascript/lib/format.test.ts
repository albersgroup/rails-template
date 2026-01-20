import { describe, expect, it } from "vitest"
import { formatCurrency, toTitleCase, truncate } from "./format"

describe("formatCurrency", () => {
  it("formats USD by default", () => {
    expect(formatCurrency(1234.56)).toBe("$1,234.56")
  })

  it("formats other currencies", () => {
    expect(formatCurrency(1234.56, "EUR")).toBe("€1,234.56")
  })

  it("handles zero", () => {
    expect(formatCurrency(0)).toBe("$0.00")
  })

  it("handles negative numbers", () => {
    expect(formatCurrency(-50)).toBe("-$50.00")
  })
})

describe("truncate", () => {
  it("returns original string if shorter than max length", () => {
    expect(truncate("hello", 10)).toBe("hello")
  })

  it("truncates and adds ellipsis", () => {
    expect(truncate("hello world", 8)).toBe("hello...")
  })

  it("handles exact length", () => {
    expect(truncate("hello", 5)).toBe("hello")
  })
})

describe("toTitleCase", () => {
  it("capitalizes first letter of each word", () => {
    expect(toTitleCase("hello world")).toBe("Hello World")
  })

  it("handles all caps input", () => {
    expect(toTitleCase("HELLO WORLD")).toBe("Hello World")
  })

  it("handles single word", () => {
    expect(toTitleCase("hello")).toBe("Hello")
  })
})
