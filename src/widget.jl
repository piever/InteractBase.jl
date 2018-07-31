export observe, Widget

WebIO.render(u::Widget) = WebIO.render((u.update(u); u.layout(u)))

Base.show(io::IO, m::MIME"text/plain", u::AbstractWidget) = show(io, m, WebIO.render(u))

function Base.show(io::IO, m::MIME"text/html", x::AbstractWidget)
    if !isijulia()
        show(io, m, WebIO.render(x))
    else
        write(io, "<div class='tex2jax_ignore $(getclass(:ijulia))'>\n")
        show(io, m, WebIO.render(x))
        write(io, "\n</div>")
    end
end

# mapping from widgets to respective scope
function scope(widget::Scope)
    Base.depwarn("`InteractBase.scope` is deprecated, use `Widgets.scope` instead", "scope")
    widget
end

function scope(widget::Widget)
    Base.depwarn("`InteractBase.scope` is deprecated, use `Widgets.scope` instead", "scope")
    widget.scope
end

_hasscope(widget::Widget) = widget.scope !== nothing
_hasscope(widget::Scope) = true
_hasscope(o) = false

function hasscope(o)
    Base.depwarn("`hasscope(o)` is deprecated, use `Widgets.scope(o) !== nothing` instead", "hasscope")
    _hasscope(o)
end

"""
sets up a primary scope for widgets
"""
function primary_scope!(w::Widget, sc)
    Base.depwarn("`primary_scope` is deprecated, use `Widgets.scope!` instead", "primary_scope!")
    w.scope = sc
end

"""
sets up a primary observable for every
widget for use in @manipulate
"""
function primary_obs!(w, ob)
    Base.depwarn("`primary_obs!` is deprecated, use `Widgets.@output!` instead", "primary_obs!")
    w.output = ob
end
primary_obs!(w, ob::AbstractString) = primary_obs!(w, (w.scope)[ob])

function wrapfield(T::WidgetTheme, ui, f = Node(:div, className = getclass(:div, "field")))
    wrap(NativeHTML(), ui, f)
end

function wrap(T::WidgetTheme, ui, f = identity)
    Base.depwarn("`wrap(ui, f)` is deprecated, use `layout(f, ui)` instead")
    ui.layout = f∘ui.layout
    ui
end

wrap(T::WidgetTheme, ui::Node, f = identity) = f(ui)
