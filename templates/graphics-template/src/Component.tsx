import { componentDidAppear, componentWillDisappear } from 'inferno-animation';

function NameTag({value, animation, ...other}) {
  return (
    <div className="NameTag">
      <div className="inner">
        <span className="name">{value['name']}</span>
      </div>
    </div>
  )
}

export default function Container({id, name, isStaged, data}) {
  return <div className="[name-of-your-package]">
    {isStaged && <NameTag
      value={data}
      onComponentDidAppear={componentDidAppear}
      onComponentWillDisappear={componentWillDisappear}
      animation="NameTagAnim" />}
  </div>
}
