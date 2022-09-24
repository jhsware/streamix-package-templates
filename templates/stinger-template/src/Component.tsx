import { componentDidAppear, componentWillDisappear } from 'inferno-animation';

export default function Container({id, name, isStaged, data}) {
  return <div className="[name-of-your-package]">
    {isStaged && <Background 
      onComponentDidAppear={componentDidAppear}
      onComponentWillDisappear={componentWillDisappear}
      animation="BackgroundAnim" />}
    {isStaged && <Title
      value={data}
      onComponentDidAppear={componentDidAppear}
      onComponentWillDisappear={componentWillDisappear}
      animation="TitleAnim" />}
  </div>
}

function Title({value, ...other}) {
  return (
    <div className="Title">
      <div className="inner">
        <span className="name">{value['name']}</span>
        <span className="title">{value['title']}</span>
      </div>
    </div>
  )
}

function Background({...other}) {
  return (
    <div className="Background">
      <div className="Plate"></div>
      <div className="Bar_1"></div>
      <div className="Bar_2"></div>
      <div className="Bar_3"></div>
      <div className="Bar_4"></div>
      <div className="Bar_5"></div>
    </div>
  )
}