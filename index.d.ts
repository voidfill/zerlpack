declare module "zerlpack" {
	export function unpack(buffer: Uint8Array): any;
	export function pack(value: any, compress?: boolean): Buffer;
}