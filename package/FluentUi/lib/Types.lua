--[[
	Exports all types that are required for Fluent to work properly
	Licensed under the MIT license
]]

export type fluent_interface = { -- allow for auto complete while styling classes
	-- any
	BorderRadius: number,
	sizeX: number,
	sizeY: number,
	Pos: UDim2,
	Background: Color3,
	Opacity: number,
	Name: string,
	hidden: boolean,
	autoColor: boolean,

	-- flex
	isFlex: boolean,
	alignX: string,
	alignY: string,
	flexOrder: string,
	flexPadding: number,

	-- boxshadow
	BoxShadow: boolean,
	boxShadowStyle: number,
	boxShadowAlpha: number,

	-- padding
	Padding: boolean,
	PaddingTop: number,
	PaddingBottom: number,
	PaddingLeft: number,
	PaddingRight: number,

	-- border
	Border: boolean,
	BorderColor: Color3,
	BorderThickness: number,
	BorderOpacity: number,
	BorderJoinMode: string,
	BorderApplyMode: string,

	-- text
	Content: string,
	FontFamily: string | Enum.Font,
	Color: Color3,
	isRichText: boolean,
	ScaledFont: boolean,

	-- events
	onhover: any,
	onunhover: any,
	active: any,
	run: any,

	-- markup
	MARKUP_VALUE: string,
}

export type fluent_component = {
	Name: string,
	Styles: fluent_interface
}

export type fluent_component_config = {
	componentName: string,
	name: string,
	type: string,
	container: any
}

-- file types
export type fluent_file_content = {
	tag: string,
	typ: string,
	par: any, -- containing parent
	opt: any, -- function for extra styling
	con: {fluent_file_content}, -- extra markup within
	MARKUP_VALUE: string
}

export type fluent_file = {
	Name: string,
	Contents: {fluent_file_content}
}

-- new
export type C_TweenService = {
    time: number,
    style: Enum.EasingStyle,
    direction: Enum.EasingDirection,
    TweenTable: {}
}

export type fluent_new_action_runtime = {
    Tween: C_TweenService
}

export type fluent_new_action_mount = {
    name: string,
    runtime: fluent_new_action_runtime
}

export type fluent_new_action = {
    Tween: boolean
}

export type fluent_new_action_manager = {
    mount: any,
    runtime: string,
    actions: fluent_new_action
}

return nil