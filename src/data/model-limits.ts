/**
 * model-limits.ts — manually curated TPM / RPM rate limits per model.
 *
 * pricing-api.json doesn't expose rate limits. Keys are exact `model_name`
 * from pricing-api.json, mirroring `model-meta.ts`'s keyed-record pattern.
 * Missing entries (or missing `tpm`/`rpm` fields) render as "—" in the
 * /models catalog list — never fabricate values.
 *
 * Default limits: TPM 1,000,000 / RPM 60 for all models, with two exceptions:
 *   - claude* models: TPM 3,000,000 (300 万) / RPM 500
 *   - deepseek-v4-pro: TPM 20,000,000 / RPM 4,000
 */
export interface ModelLimits {
  /** Tokens per minute. */
  tpm?: number;
  /** Requests per minute. */
  rpm?: number;
}

const DEFAULT = { tpm: 1_000_000, rpm: 60 };
const CLAUDE = { tpm: 3_000_000, rpm: 500 };
const DEEPSEEK_V4_PRO = { tpm: 20_000_000, rpm: 4_000 };

export const modelLimits: Record<string, ModelLimits> = {
  // ── Anthropic (Claude) — special: 300 万 tpm / 500 rpm
  'claude-fable-5': CLAUDE,
  'claude-haiku-4-5-20251001': CLAUDE,
  'claude-opus-4-5-20251101': CLAUDE,
  'claude-opus-4-6': CLAUDE,
  'claude-opus-4-7': CLAUDE,
  'claude-opus-4-8': CLAUDE,
  'claude-sonnet-4-5-20250929': CLAUDE,
  'claude-sonnet-4-6': CLAUDE,

  // ── DeepSeek — special: 20,000,000 tpm / 4,000 rpm
  'deepseek-v4-pro': DEEPSEEK_V4_PRO,

  // ── Google Gemini — default
  'gemini-2.5-flash': DEFAULT,
  'gemini-2.5-flash-image': DEFAULT,
  'gemini-2.5-flash-lite': DEFAULT,
  'gemini-2.5-pro': DEFAULT,
  'gemini-3-pro-image': DEFAULT,
  'gemini-3.1-flash-image': DEFAULT,
  'gemini-3.1-flash-lite': DEFAULT,
  'gemini-3.1-pro-preview': DEFAULT,
  'gemini-3.5-flash': DEFAULT,

  // ── OpenAI GPT — default
  'gpt-5.2': DEFAULT,
  'gpt-5.2-chat': DEFAULT,
  'gpt-5.2-codex': DEFAULT,
  'gpt-5.3-codex': DEFAULT,
  'gpt-5.4': DEFAULT,
  'gpt-5.4-mini': DEFAULT,
  'gpt-5.4-nano': DEFAULT,
  'gpt-5.5': DEFAULT,
  'gpt-5.6-luna': DEFAULT,
  'gpt-5.6-sol': DEFAULT,
  'gpt-5.6-terra': DEFAULT,
  'gpt-image-2': DEFAULT,
};

export function limitsOf(name: string): ModelLimits | undefined {
  return modelLimits[name];
}
