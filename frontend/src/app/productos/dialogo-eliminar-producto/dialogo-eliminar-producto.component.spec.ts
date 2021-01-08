import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DialogoEliminarProductoComponent } from './dialogo-eliminar-producto.component';

describe('DialogoEliminarProductoComponent', () => {
  let component: DialogoEliminarProductoComponent;
  let fixture: ComponentFixture<DialogoEliminarProductoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DialogoEliminarProductoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DialogoEliminarProductoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
